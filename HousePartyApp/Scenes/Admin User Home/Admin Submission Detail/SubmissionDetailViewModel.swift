//
//  SubmissionDetailViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/29/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SubmissionDetailViewModel {
    
    //MARK: - Properties
    private let _submission: Variable<Submission>
    let disposeBag = DisposeBag()
    weak var coordinator: HomeCoordinator?
    private let _shouldDismiss: Variable<Bool>
    
    init(submission: Submission, coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self._shouldDismiss = Variable(false)
        self._submission = Variable(submission)
    }
    
    //MARK: - Outputs
    var displayedSubmission: Observable<Submission> {
        return _submission.asObservable().skip(1)
    }
    
    var displayedUsers: Observable<[Invitable]> {
        return _submission.asObservable().map { self.createInvitableUsersFrom(submission: $0) }
    }
    
    var shouldHideAddToEventButton: Observable<Bool> {
        return .just(!AppController.shared.currentUser!.isAdmin)
    }
    
    var shouldDismiss: Driver<Bool> {
        return _shouldDismiss.asDriver()
    }
    
    //MARK: - Inputs
    func bindSelectedEvent(_ observable: Observable<Event>) {
        observable
            .subscribe(onNext: { event in
                print("Event was selected: \(event.venueName)")
                let idx = AppController.shared.currentUser!.events.index(where: { $0._id == event._id })
                var subCopy = self._submission.value
                subCopy.status = .invited
                AppController.shared.currentUser!.events[idx!].submissions.append(subCopy)
                NotificationCenter.default.post(name: .changedSubmissionStatusInDetail, object: nil)
                self._shouldDismiss.value = true
            })
            .disposed(by: disposeBag)
    }
    
    func bindBackButton(_ observable: Observable<Void>) {
        observable
            .do(onNext: { self._submission.value.createdAt = Date() })
            .subscribe(onNext: { self.coordinator?.toPreviousScreen() })
            .disposed(by: disposeBag)
    }
    
}

extension SubmissionDetailViewModel {
    private func createInvitableUsersFrom(submission: Submission) -> [Invitable] {
        var invitableUsers = [Invitable]()
        invitableUsers.append(submission.leader)
        submission.registeredFriends.forEach { invitableUsers.append($0) }
        submission.unregisteredFriends.forEach { invitableUsers.append($0) }
        return invitableUsers
    }
}

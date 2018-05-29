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
    private let disposeBag = DisposeBag()
    private let coordinator: AdminHomeCoordinator
    
    init(submission: Submission, coordinator: AdminHomeCoordinator) {
        self.coordinator = coordinator
        _submission = Variable(submission)
    }
    
    //MARK: - Outputs
    var displayedUsers: Observable<[Invitable]> {
        return _submission.asObservable().map { self.createInvitableUsersFrom(submission: $0) }
    }
    
    var shouldHideAddToEventButton: Observable<Bool> {
        return .just(!AppController.shared.currentUser!.isAdmin)
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
                self.coordinator.toPreviousScreen()
            })
            .disposed(by: disposeBag)
    }
    
    func bindBackButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.coordinator.toPreviousScreen() })
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

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
    private let _usersGroup = Variable<[Invitable]>([])
    private let disposeBag = DisposeBag()
    
    init(submission: Submission) {
        _usersGroup.value = createInvitableUsersFrom(submission: submission)
    }
    
    //MARK: - Outputs
    var displayedUsers: Observable<[Invitable]> {
        return _usersGroup.asObservable()
    }
    
    //MARK: - Inputs
    func bindDidSelectEvent(_ observable: Observable<Event>) {
        observable
            .subscribe(onNext: { print("Submission selected: \($0.date)") })
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

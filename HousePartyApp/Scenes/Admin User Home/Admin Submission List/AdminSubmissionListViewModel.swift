//
//  AdminSubmissionListViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/29/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

var globalSubService = SubmissionService()

struct SubmissionService {
    
    var _submissions = Variable<[Submission]>(SubmissionService.createDefaultSubs())
    
    func submissionsFor(status: SubmissonStatus) -> Observable<[Submission]> {
        return _submissions.asObservable().map { $0.filter { $0.status == .pending } }
    }
    
    static func createDefaultSubs() -> [Submission] {
        let sub1 = Submission(leader: User.defaultUser(),
                              registeredFriends: [],
                              unregisteredFriends: [],
                              allNumbers: ["2016023215"],
                              createdAt: Date(),
                              status: .pending)
        let sub2 = Submission(leader: User.defaultUser(),
                              registeredFriends: [],
                              unregisteredFriends: [],
                              allNumbers: ["2013023215"],
                              createdAt: Date(),
                              status: .pending)
        return [sub1, sub2]
    }
 }

struct AdminSubmissionListViewModel: SubmissionListInputsOutputs {
    
    //MARK: - Properties
    private let _submissions = Variable<[Submission]>([])
    private let disposeBag = DisposeBag()
    private let coordinator: AdminHomeCoordinator
    
    init(submissionService: SubmissionService = SubmissionService(), coordinator: AdminHomeCoordinator) {
        self.coordinator = coordinator
        submissionService.submissionsFor(status: .pending)
            .bind(to: _submissions)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    var displayedSubmissions: Observable<[Submission]> {
        return _submissions.asObservable()
    }
    
    //MARK: - Inputs
    func bindDidSelectSubmission(_ observable: Observable<Submission>) {
        observable
            .subscribe(onNext: { self.coordinator.navigateTo(screen: .submissionDetail($0)) })
            .disposed(by: disposeBag)
    }
    
}

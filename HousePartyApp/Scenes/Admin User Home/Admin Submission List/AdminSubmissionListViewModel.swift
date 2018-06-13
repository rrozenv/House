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
        let sub1 = Submission(eventId: nil,
                              leader: User.defaultUser(),
                              registeredFriends: [],
                              unregisteredFriends: [],
                              allNumbers: ["2016023215"],
                              createdAt: Date(),
                              status: .pending,
                              purchasedTickets: 0)
        let sub2 = Submission(eventId: nil,
                              leader: User.defaultUser(),
                              registeredFriends: [],
                              unregisteredFriends: [],
                              allNumbers: ["2013023215"],
                              createdAt: Date(),
                              status: .pending,
                              purchasedTickets: 0)
        return [sub1, sub2]
    }
 }

struct AdminSubmissionListViewModel: SubmissionListInputsOutputs {
    
    //MARK: - Properties
    private let _submissions = Variable<[Submission]>([])
    private let disposeBag = DisposeBag()
    private weak var coordinator: HomeCoordinator?
    private let selectedIndex = Variable(0)
    
    init(submissionService: SubmissionService = SubmissionService(), coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        submissionService.submissionsFor(status: .pending)
            .bind(to: _submissions)
            .disposed(by: disposeBag)
        bindShouldRemoveSubmissionNotification()
    }
    
    //MARK: - Outputs
    var displayedSubmissions: Observable<[Submission]> {
        return _submissions.asObservable()
    }
    
    //MARK: - Inputs
    func bindSelectedSubmissionIndex(_ observable: Observable<Int>) {
        observable
            .do(onNext: { self.selectedIndex.value = $0 })
            .mapToVoid()
            .subscribe()
            .disposed(by: disposeBag)
//        observable
//            .do(onNext: { self.selectedIndex.value = $0 })
//            .subscribe(onNext: { index in
//                self.coordinator?.navigateTo(screen: .submissionDetail(self._submissions.value[], <#T##Int#>, <#T##SubmissionListViewModel#>))
//            })
//            .disposed(by: disposeBag)
    }
    
    private func bindShouldRemoveSubmissionNotification() {
        NotificationCenter.default.rx.notification(.changedSubmissionStatusInDetail)
            .subscribe(onNext: { _ in self._submissions.value.remove(at: self.selectedIndex.value) })
            .disposed(by: disposeBag)
    }
    
}

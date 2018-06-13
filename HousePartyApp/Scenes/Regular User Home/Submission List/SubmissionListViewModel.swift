//
//  SubmissionListViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/26/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SubmissionListInputsOutputs {
    var displayedSubmissions: Observable<[Submission]> { get }
    func bindSelectedSubmissionIndex(_ observable: Observable<Int>)
}

struct SubmissionListViewModel: SubmissionListInputsOutputs {
    
    //MARK: - Properties
    private let _submissions = Variable<[Submission]>([])
    let disposeBag = DisposeBag()
    private weak var coordinator: HomeCoordinator?
    var updatedSubmission = Variable<(Submission, Int)?>(nil)
    
    init(user: User, coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self._submissions.value = user.submissons
        self.bindUserDidUpdateNotification()
        self.bindUpdatedSubmission()
    }
    
    //MARK: - Outputs
    var displayedSubmissions: Observable<[Submission]> {
        return _submissions.asObservable()
    }
    
    //MARK: - Inputs
    func bindSelectedSubmissionIndex(_ observable: Observable<Int>) {
        observable
            .subscribe(onNext: { index in
                self.coordinator?
                .navigateTo(screen: .submissionDetail(self._submissions.value[index], index, self))
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUpdatedSubmission() {
        updatedSubmission.asObservable().filterNil()
            .subscribe(onNext: { sub, index in
                print("sub id:\(sub.createdAt) updated at: \(index)")
                self._submissions.value[index] = sub
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper Methods
    private func bindUserDidUpdateNotification() {
        NotificationCenter.default.rx.notification(.userDidUpdate)
            .subscribe(onNext: { _ in
                self._submissions.value = AppController.shared.currentUser!.submissons
            })
            .disposed(by: disposeBag)
    }
}

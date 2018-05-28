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

struct SubmissionListViewModel {
    
    //MARK: - Properties
    private let _submissions = Variable<[Submission]>([])
    private let disposeBag = DisposeBag()
    
    init(user: User) {
        _submissions.value = user.submissons
        bindUserDidUpdateNotification()
    }
    
    //MARK: - Outputs
    var displayedSubmissions: Observable<[Submission]> {
        return _submissions.asObservable()
    }
    
    //MARK: - Inputs
    func bindDidSelectSubmission(_ observable: Observable<Submission>) {
        observable
            .subscribe(onNext: { print("Submission selected: \($0.createdAt)") })
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

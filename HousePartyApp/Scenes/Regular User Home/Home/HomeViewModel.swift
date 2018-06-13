//
//  HomeViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

typealias TabInfo = (vcs: [UIViewController], appearance: TabAppearence)

protocol HomeViewControllable {
    var coordinator: HomeCoordinator { get }
    var tabInfo: Driver<TabInfo> { get }
    func bindCreateButton(_ observable: Observable<Void>)
}

struct HomeViewModel: HomeViewControllable {
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    let coordinator: HomeCoordinator
    
    init(coordinator: HomeCoordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - Outputs
    var tabInfo: Driver<TabInfo> {
        return Driver.of(createTabInfo())
    }
    
    //MARK: - Inputs
    func bindCreateButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: {
                self.coordinator.navigateTo(screen: .createSubmission)
            })
            .disposed(by: disposeBag)
    }
    
}

extension HomeViewModel {
    private func createTabInfo() -> TabInfo {
        var submissionVc = SubmissionListViewController<SubmissionListViewModel>()
        let submissionVm = SubmissionListViewModel(user: AppController.shared.currentUser!, coordinator: self.coordinator)
        submissionVc.setViewModelBinding(model: submissionVm)
        
        let apperence = TabAppearence(type: .underline,
                                      itemTitles: ["Submissions", "Events"],
                                      height: 50.0,
                                      selectedBkgColor: .white,
                                      selectedTitleColor: .black,
                                      notSelectedBkgColor: .white,
                                      notSelectedTitleColor: .black)
        return TabInfo(vcs: [submissionVc, UIViewController()], appearance: apperence)
    }
}

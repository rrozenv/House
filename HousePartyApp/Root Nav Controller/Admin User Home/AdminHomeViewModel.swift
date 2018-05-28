//
//  AdminHomeViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AdminHomeViewModel: HomeViewControllable {
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let coordinator: AdminHomeCoordinator
    
    init(coordinator: AdminHomeCoordinator) {
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
                self.coordinator.navigateTo(screen: .createEvent)
            })
            .disposed(by: disposeBag)
    }
    
}

extension AdminHomeViewModel {
    private func createTabInfo() -> TabInfo {
        var eventsVc = EventListViewController()
        let submissionVm = EventListViewModel(user: AppController.shared.currentUser!)
        eventsVc.setViewModelBinding(model: submissionVm)
        let apperence = TabAppearence(type: .underline,
                                      itemTitles: ["Events", "Submissions"],
                                      height: 50.0,
                                      selectedBkgColor: .white,
                                      selectedTitleColor: .black,
                                      notSelectedBkgColor: .white,
                                      notSelectedTitleColor: .black)
        return TabInfo(vcs: [eventsVc, UIViewController()], appearance: apperence)
    }
}

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

protocol AdminHomeCoordinatorDelegate {
    func didTapCreateEventButton(_ vm: AdminHomeViewModel)
}

struct AdminHomeViewModel: HomeViewControllable {
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    let coordinator: HomeCoordinator
    var newEvent = Variable<Event?>(nil)
    
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
                self.coordinator.navigateTo(screen: .createEventTest(self))
            })
            .disposed(by: disposeBag)
    }
    
}

extension AdminHomeViewModel {
    private func createTabInfo() -> TabInfo {
        var eventsVc = EventListViewController(style: .fullScreen)
        let submissionVm = EventListViewModel(user: AppController.shared.currentUser!)
        eventsVc.setViewModelBinding(model: submissionVm)
        newEvent.asObservable().filterNil()
            .subscribe(onNext: { submissionVm.addEvent($0) })
            .disposed(by: submissionVm.disposeBag)
        
        var adminSubListVc = SubmissionListViewController<AdminSubmissionListViewModel>()
        let adminSubmVm = AdminSubmissionListViewModel(submissionService: globalSubService, coordinator: coordinator)
        adminSubListVc.setViewModelBinding(model: adminSubmVm)
        
        let apperence = TabAppearence(type: .underline,
                                      itemTitles: ["Events", "Submissions"],
                                      height: 50.0,
                                      selectedBkgColor: .white,
                                      selectedTitleColor: .black,
                                      notSelectedBkgColor: .white,
                                      notSelectedTitleColor: .black)
        
        return TabInfo(vcs: [eventsVc, adminSubListVc], appearance: apperence)
    }
}

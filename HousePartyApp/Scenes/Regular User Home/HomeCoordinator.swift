//
//  HomeCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/26/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift



final class HomeCoordinator: Coordinatable {

    enum Screen {
        case home
        case adminHome
        case createEvent(CreateEventCoordinator)
        case createEventTest(AdminHomeViewModel)
        case createSubmission
        case submissionDetail(Submission, Int, SubmissionListViewModel)
    }
    
    weak var navigationController: UINavigationController?
    
    init(navVc: UINavigationController) {
        self.navigationController = navVc
        navVc.isNavigationBarHidden = true
    }
    
    func navigateTo(screen: Screen) {
        switch screen {
        case .home: toHome()
        case .adminHome: toAdminHome()
        case .createEvent(let coor): toCreateEvent(coor)
        case .createEventTest(let vm): toCreateEventTest(vm)
        case .createSubmission: toCreateSubmission()
        case .submissionDetail(let sub, let index, let vm): toSubmissionDetail(sub, index, vm)
        }
    }
    
    func toPreviousScreen() {
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("HomeCoordinator deinit")
    }

    //MARK: - Navigating
    private func toHome() {
        var vc = HomeViewController<HomeViewModel>()
        let vm = HomeViewModel(coordinator: self)
        vc.setViewModelBinding(model: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toAdminHome() {
        var vc = HomeViewController<AdminHomeViewModel>()
        let vm = AdminHomeViewModel(coordinator: self)
        vc.setViewModelBinding(model: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toCreateEvent(_ coor: CreateEventCoordinator) {
//        let navVc = UINavigationController()
//        let coordinator = CreateEventCoordinator(navVc: navVc, screenOrder: [.selectLocation])
//        coordinator.createdEvent.asObservable()
//            .bind(to: vm.newEvent)
//            .disposed(by: coordinator.disposeBag)
        coor.toNextScreen()
        navigationController?.present(coor.navigationController!, animated: true, completion: nil)
    }
    
    private func toCreateEventTest(_ vm: AdminHomeViewModel) {
        let navVc = UINavigationController()
        let coordinator = CreateEventCoordinator(navVc: navVc, screenOrder: [.selectLocation])
        coordinator.createdEvent.asObservable()
            .bind(to: vm.newEvent)
            .disposed(by: coordinator.disposeBag)
        coordinator.toNextScreen()
        navigationController?.present(navVc, animated: true, completion: nil)
    }
    
    private func toCreateSubmission() {
        let navVc = UINavigationController()
        let coordinator = CreateSubmissionCoordinator(navVc: navVc, screenOrder: [.selectSqaud, .squadDescription])
        coordinator.toNextScreen()
        navigationController?.present(navVc, animated: true, completion: nil)
    }
    
    private func toSubmissionDetail(_ submission: Submission, _ index: Int, _ listVm: SubmissionListViewModel) {
        var vc = SubmissionDetailViewController()
        let vm = SubmissionDetailViewModel(submission: submission, coordinator: self)
        vm.displayedSubmission
            .map { ($0, index) }
            .bind(to: listVm.updatedSubmission)
            .disposed(by: vm.disposeBag)
        vc.setViewModelBinding(model: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

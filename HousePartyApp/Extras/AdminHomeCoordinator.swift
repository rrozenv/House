//
//  AdminHomeCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

//final class AdminHomeCoordinator: Coordinatable {
//    
//    enum Screen {
//        case home
//        case createEvent
//        case submissionDetail(Submission)
//    }
//    
//    weak var navigationController: UINavigationController?
//    let screens: [Screen]
//    
//    init(navVc: UINavigationController,
//         screens: [Screen]) {
//        self.navigationController = navVc
//        self.screens = screens
//        navVc.isNavigationBarHidden = true
//    }
//    
//    func navigateTo(screen: Screen) {
//        switch screen {
//        case .home: toHome()
//        case .createEvent: toCreateSubmission()
//        case .submissionDetail(let submission): toSubmissionDetail(submission)
//        }
//    }
//    
//    func toPreviousScreen() {
//        navigationController?.popViewController(animated: true)
//    }
//    
//    //MARK: - Navigating
//    private func toSubmissionDetail(_ submission: Submission) {
//        var vc = SubmissionDetailViewController()
//        let vm = SubmissionDetailViewModel(submission: submission, coordinator: self)
//        vc.setViewModelBinding(model: vm)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    private func toHome() {
//        var vc = HomeViewController<AdminHomeViewModel>()
//        let vm = AdminHomeViewModel(coordinator: self)
//        vc.setViewModelBinding(model: vm)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    private func toCreateSubmission() {
//        let navVc = UINavigationController()
//        let coordinator = CreateEventCoordinator(navVc: navVc, screenOrder: [.selectLocation])
//        coordinator.toNextScreen()
//        navigationController?.present(navVc, animated: true, completion: nil)
//    }
//    
//}


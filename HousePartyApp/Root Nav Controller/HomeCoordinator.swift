//
//  HomeCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/26/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class HomeCoordinator {
    
    enum Screen: Int {
        case home
        case createSubmission
        case submissionDetail
    }
    
    weak var navigationController: UINavigationController?
    let screens: [Screen]
    
    init(navVc: UINavigationController,
         screens: [Screen]) {
        self.navigationController = navVc
        self.screens = screens
        navVc.isNavigationBarHidden = true
    }
    
    func navigateTo(screen: Screen) {
        switch screen {
        case .home: toHome()
        case .createSubmission: toCreateSubmission()
        case .submissionDetail: toSubmissionDetail()
        }
    }

    //MARK: - Navigating
    private func toSubmissionDetail() {
        print("Going to submission detail screen!")
    }
    
    private func toHome() {
        let vc = HomeViewController(coordinator: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toCreateSubmission() {
        let navVc = UINavigationController()
        let coordinator = CreateSubmissionCoordinator(navVc: navVc, screenOrder: [.selectSqaud, .squadDescription])
        coordinator.toNextScreen()
        navigationController?.present(navVc, animated: true, completion: nil)
    }
    
}

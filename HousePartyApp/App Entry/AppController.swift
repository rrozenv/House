//
//  AppController.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class AppController: UIViewController {
    
    //MARK: - Properties
    static let shared = AppController(userService: UserService())
    private let userService: UserService
    private var actingVC: UIViewController!
    var currentUser: User?
    var signupFlowCoordinator: SignUpFlowCoordinator!
    
    private init(userService: UserService) {
        self.userService = userService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIApplication.shared.isStatusBarHidden = true
        addNotificationObservers()
        loadInitialViewController()
    }
    
}

// MARK: - Notficiation Observers
extension AppController {
    
    fileprivate func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .createHomeVc, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(switchViewController(with:)), name: .logout, object: nil)
    }
    
}

// MARK: - Loading VC's
extension AppController {
    
    private func loadInitialViewController() {
        self.actingVC = (currentUser != nil) ?
            createHomeViewController() : toOnboardingFlow()
        self.addChild(actingVC, frame: view.frame, animated: true)
    }

    private func toOnboardingFlow() -> UINavigationController {
        let navVc = UINavigationController()
        let coordinator =
            SignUpFlowCoordinator(navVc: navVc,
                                  screenOrder: [.inital, .selectCity, .firstName, .lastName, .phoneNumber, .phoneVerification])
        coordinator.toNextScreen()
        return navVc
    }

    private func createHomeViewController() -> UINavigationController {
        var navVc: UINavigationController
        if let user = currentUser, user.events.isEmpty {
            navVc = UINavigationController(rootViewController: HomeViewController())
        } else {
            var vc = SelectSquadViewController()
            let viewModel = SelectSquadViewModel()
            vc.setViewModelBinding(model: viewModel)
            navVc = UINavigationController(rootViewController: vc)
            navVc.isNavigationBarHidden = true
        }
        return navVc
    }
    
}

// MARK: - Displaying VC's
extension AppController {
    
    @objc func switchViewController(with notification: Notification) {
        switch notification.name {
        case Notification.Name.createHomeVc:
            switchToViewController(self.createHomeViewController())
        case Notification.Name.logout:
            switchToViewController(self.toOnboardingFlow())
        default:
            fatalError("\(#function) - Unable to match notficiation name.")
        }
    }

    private func switchToViewController(_ viewController: UIViewController) {
        self.removeChild(actingVC, completion: nil)
        self.actingVC = viewController
        self.addChild(viewController, frame: view.frame, animated: true)
    }
    
}

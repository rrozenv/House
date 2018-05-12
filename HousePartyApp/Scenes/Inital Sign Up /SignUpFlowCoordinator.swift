//
//  SignUpFlowCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/11/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class SignupInfo {
    var fullName: String?
    var phoneNumber: String?
    
    init(fullName: String?, phoneNumber: String?) {
        self.fullName = fullName
        self.phoneNumber = phoneNumber
    }
}

final class SignUpFlowCoordinator {
    
    private weak var navigationController: UINavigationController?
    private var signupInfo = SignupInfo(fullName: nil, phoneNumber: nil)
    private let finalSignupInfo = PublishSubject<SignupInfo>()
    var didFinishSignup: Observable<SignupInfo> {
        return finalSignupInfo.asObservable()
    }
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func toUserDetails() {
        var vc = UserDetailsViewController()
        let viewModel = UserDetailsViewModel(router: self)
        vc.setViewModelBinding(model: viewModel)
        viewModel.inputs.viewDidLoadInput.onNext(())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toOnboardingFlow() {
        let vcs = OnboardingInfo.initalOnboardingInfo.map { OnboardingViewController.configuredWith(info: $0)
        }
        let pageVc = OnboardingPageViewController(viewControllers: vcs)
        navigationController?.pushViewController(pageVc, animated: true)
    }
    
    func didSaveName(_ fullName: String) {
        signupInfo.fullName = fullName
        print("To phone")
    }
    
    func didSavePhoneNumber(_ number: String) {
        signupInfo.phoneNumber = number
        finalSignupInfo.onNext(signupInfo)
    }
    
    func dismiss() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
}

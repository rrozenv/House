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
    
    private let disposeBag = DisposeBag()
    private weak var navigationController: UINavigationController?
    private var signupInfo = SignupInfo(fullName: nil, phoneNumber: nil)
    private var userService: UserService
    
    init(navVc: UINavigationController, userService: UserService = UserService()) {
        self.navigationController = navVc
        self.userService = userService
    }
    
    func toUserDetails() {
        var vc = UserDetailsViewController()
        let viewModel = UserDetailsViewModel(router: self)
        vc.setViewModelBinding(model: viewModel)
        viewModel.inputs.viewDidLoadInput.onNext(())
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func toPhoneEntry() {
        var vc = PhoneEntryViewController()
        let viewModel = PhoneEntryViewModel(router: self)
        vc.setViewModelBinding(model: viewModel)
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
        toPhoneEntry()
    }
    
    func didSavePhoneNumber(_ number: String) {
        signupInfo.phoneNumber = number
        createUser()
    }
    
    private func createUser() {
        guard let name = signupInfo.fullName,
             let phone = signupInfo.phoneNumber else {
                print("Missing user creds!") ; return
        }
        let user = User(fullName: name,
                        birthDate: "Test Birthday",
                        phoneNumber: phone)
        
        userService.create(user: user.toJSON())
            .subscribe(onNext: {
                print("Created user: \($0.fullName)")
            })
            .disposed(by: disposeBag)
    }
    
//    func dismiss() {
//        navigationController?.dismiss(animated: true, completion: nil)
//    }
    
}

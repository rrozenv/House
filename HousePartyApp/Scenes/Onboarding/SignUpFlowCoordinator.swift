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
    var firstName: String?
    var lastName: String?
    var city: String?
    var phoneNumber: String?
    
    init() {
        self.firstName = nil
        self.lastName = nil
        self.city = nil
        self.phoneNumber = nil
    }
    
    init(firstName: String?, lastName: String, city: String?, phoneNumber: String?) {
        self.firstName = firstName
        self.lastName = lastName
        self.city = city
        self.phoneNumber = phoneNumber
    }
}

final class SignUpFlowCoordinator {
    
    enum Screen: Int {
        case inital
        case selectCity
        case firstName
        case lastName
        case phoneNumber
        case phoneVerification
    }
    
    private let disposeBag = DisposeBag()
    private weak var navigationController: UINavigationController?
    private var signupInfo = SignupInfo()
    private var userService: UserService
    private let screenOrder: [Screen]
    private var screenIndex = -1
    
    init(navVc: UINavigationController,
         screenOrder: [Screen],
         userService: UserService = UserService()) {
        self.navigationController = navVc
        self.screenOrder = screenOrder
        self.userService = userService
    }
    
    func toNextScreen() {
        guard screenIndex < screenOrder.count - 1 else {
            print("No more screens") ; return
        }
        screenIndex += 1
        navigateTo(screen: screenOrder[screenIndex])
    }
    
    func toPreviousScreen() {
        guard screenIndex != 0 else {
            print("This is the first screen") ; return
        }
        screenIndex -= 1
        navigationController?.popViewController(animated: true)
    }
    
    private func navigateTo(screen: Screen) {
        switch screen {
        case .inital: toOnboardingFlow()
        case .selectCity: toSelectCity()
        case .firstName: toNameEntry(nameType: .first)
        case .lastName: toNameEntry(nameType: .last)
        case .phoneNumber: toPhoneEntry()
        case .phoneVerification: toPhoneVerification()
        }
    }
    
    //MARK: - Saving Functions
    func saveCity(_ city: String) {
        signupInfo.city = city
        toNextScreen()
    }
    
    func didSaveName(_ name: String, nameType: EnterNameViewModel.NameType) {
        switch nameType {
        case .first: signupInfo.firstName = name
        case .last: signupInfo.lastName = name
        }
        toNextScreen()
    }
    
    func didSavePhoneNumber(_ number: String) {
        signupInfo.phoneNumber = number
        toNextScreen()
    }
    
    func didVerifyPhoneNumberCode() {
        NotificationCenter.default.post(name: Notification.Name.createHomeVc, object: nil)
        //createUser()
    }
    
    //MARK: - Navigating
    private func toOnboardingFlow() {
        let vcs = OnboardingInfo.initalOnboardingInfo.map { InitialViewController.configuredWith(info: $0)
        }
        let pageVc = InitialPagingViewController(viewControllers: vcs, coordinator: self)
        navigationController?.pushViewController(pageVc, animated: true)
    }
    
    private func toSelectCity() {
        var vc = SelectCityViewController()
        let viewModel = SelectCityViewModel(coordinator: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toNameEntry(nameType: EnterNameViewModel.NameType) {
        var vc = EnterNameViewController()
        let viewModel = EnterNameViewModel(coordinator: self, nameType: nameType)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func toPhoneEntry() {
        var vc = PhoneEntryViewController()
        let viewModel = PhoneEntryViewModel(coordinator: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func toPhoneVerification() {
        var vc = PhoneVerificationViewController()
        let viewModel = PhoneVerificationViewModel(coordinator: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func createUser() {
        guard let name = signupInfo.firstName,
             let phone = signupInfo.phoneNumber else {
                print("Missing user creds!") ; return
        }
        let user = User(fullName: name,
                        birthDate: "Test Birthday",
                        phoneNumber: phone)
        userService.create(user: user.toJSON())
            .subscribe(onNext: {
                AppController.shared.currentUser = $0
                print("Created user: \($0.fullName)")
            })
            .disposed(by: disposeBag)
    }

}

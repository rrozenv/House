//
//  CreateSubmissionCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class SubmissionInfo {
    var leaderNumber: String?
    var selectedContacts: [Contact]?

    init() {
        self.leaderNumber = nil
        self.selectedContacts = nil
    }
}

protocol Coordinatable: class {
    associatedtype Screen
    var screenOrder: [Screen] { get }
    var screenIndex: Int { get set }
    weak var navigationController: UINavigationController? { get }
    func toNextScreen()
    func toPreviousScreen()
    func navigateTo(screen: Screen)
}

extension Coordinatable {
    
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
    
}

final class CreateSubmissionCoordinator: Coordinatable {
  
    enum Screen: Int {
        case selectSqaud
    }
    
    private let disposeBag = DisposeBag()
    weak var navigationController: UINavigationController?
    private var submissionInfo = SubmissionInfo()
    let screenOrder: [Screen]
    var screenIndex = -1
    
    init(navVc: UINavigationController,
         screenOrder: [Screen]) {
        self.navigationController = navVc
        self.screenOrder = screenOrder
    }
    
    func navigateTo(screen: Screen) {
        switch screen {
        case .selectSqaud: break //toOnboardingFlow()
        }
    }
    
    //MARK: - Saving Functions
    func saveSelectedContacts(_ contacts: [Contact]) {
        submissionInfo.selectedContacts = contacts
        toNextScreen()
    }
//
//    func didSaveName(_ name: String, nameType: EnterNameViewModel.NameType) {
//        switch nameType {
//        case .first: signupInfo.firstName = name
//        case .last: signupInfo.lastName = name
//        }
//        toNextScreen()
//    }
//
//    func didSavePhoneNumber(_ number: String) {
//        signupInfo.phoneNumber = number
//        toNextScreen()
//    }
//
//    func didVerifyPhoneNumberCode() {
//        NotificationCenter.default.post(name: Notification.Name.createHomeVc, object: nil)
//        //createUser()
//    }
//
//    //MARK: - Navigating
//    private func toOnboardingFlow() {
//        let vcs = OnboardingInfo.initalOnboardingInfo.map { InitialViewController.configuredWith(info: $0)
//        }
//        let pageVc = InitialPagingViewController(viewControllers: vcs, coordinator: self)
//        navigationController?.pushViewController(pageVc, animated: true)
//    }
//
//    private func toSelectCity() {
//        var vc = SelectCityViewController()
//        let viewModel = SelectCityViewModel(coordinator: self)
//        vc.setViewModelBinding(model: viewModel)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    private func toNameEntry(nameType: EnterNameViewModel.NameType) {
//        var vc = EnterNameViewController()
//        let viewModel = EnterNameViewModel(coordinator: self, nameType: nameType)
//        vc.setViewModelBinding(model: viewModel)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    private func toPhoneEntry() {
//        var vc = PhoneEntryViewController()
//        let viewModel = PhoneEntryViewModel(coordinator: self)
//        vc.setViewModelBinding(model: viewModel)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    private func toPhoneVerification() {
//        var vc = PhoneVerificationViewController()
//        let viewModel = PhoneVerificationViewModel(coordinator: self)
//        vc.setViewModelBinding(model: viewModel)
//        navigationController?.pushViewController(vc, animated: true)
//    }
//
//    private func createUser() {
//        guard let name = signupInfo.firstName,
//            let phone = signupInfo.phoneNumber else {
//                print("Missing user creds!") ; return
//        }
//        let user = User(fullName: name,
//                        birthDate: "Test Birthday",
//                        phoneNumber: phone)
//        userService.create(user: user.toJSON())
//            .subscribe(onNext: {
//                AppController.shared.currentUser = $0
//                print("Created user: \($0.fullName)")
//            })
//            .disposed(by: disposeBag)
//    }
    
}

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
    var squadDescription: String?
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
            print("This is the first screen")
            navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        screenIndex -= 1
        navigationController?.popViewController(animated: true)
    }
    
}

final class CreateSubmissionCoordinator: Coordinatable {
  
    enum Screen: Int {
        case selectSqaud
        case squadDescription
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
        navVc.isNavigationBarHidden = true
    }
    
    func navigateTo(screen: Screen) {
        switch screen {
        case .selectSqaud: toSelectSquad()
        case .squadDescription: toSquadDescription()
        }
    }
    
    //MARK: - Saving Functions
    func saveSelectedContacts(_ contacts: [Contact]) {
        submissionInfo.selectedContacts = contacts
        contacts.forEach {
            print($0.fullName)
        }
        toNextScreen()
    }
    
    func saveSquadDescription(_ desc: String) {
        submissionInfo.squadDescription = desc
        flowWillFinish()
    }
    
    func flowWillFinish() {
        let submission = Submission(leader: AppController.shared.currentUser!, registeredFriends: [], unregisteredFriends: [], allNumbers: submissionInfo.selectedContacts!.map { $0.primaryNumber! }, createdAt: Date(), status: .pending)
        print("Submission: \(submission)")
        //TODO: Create Submission
    }

    //MARK: - Navigating
    private func toSelectSquad() {
        var vc = SelectSquadViewController()
        let viewModel = SelectSquadViewModel(coordinator: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }

    private func toSquadDescription() {
        guard let selectedContacts = submissionInfo.selectedContacts else { fatalError("No Contacts selected!") }
        var vc = SquadDescriptionViewController()
        let viewModel = SquadDescriptionViewModel(selectedContacts: selectedContacts, coordinator: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

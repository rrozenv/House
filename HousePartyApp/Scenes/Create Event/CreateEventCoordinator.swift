//
//  CreateEventCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

final class EventInfo {
    var location: String?
    var date: Date?
}

final class CreateEventCoordinator: Coordinatable {
    
    enum Screen: Int {
        case selectLocation
        case selectTime
    }
    
    private let disposeBag = DisposeBag()
    weak var navigationController: UINavigationController?
    private var eventInfo = EventInfo()
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
        case .selectLocation: toSelectLocation()
        case .selectTime: break
        }
    }
    
    //MARK: - Saving Functions
    func saveSelectedLocation(_ location: String) {
        eventInfo.location = location
        flowWillFinish()
    }
    
    func saveSelectedDate(_ date: Date) {
        eventInfo.date = date
        toNextScreen()
    }
    
    func flowWillFinish() {
        print(AppController.shared.currentUser ?? "No user")
        let event = Event(_id: UUID().uuidString,
                          venueName: eventInfo.location!,
                          date: Date(),
                          submissions: [])
        AppController.shared.currentUser!.events.append(event)
        navigationController?.dismiss(animated: true, completion: nil)
        //TODO: Create Submission
    }
    
    //MARK: - Navigating
    private func toSelectLocation() {
        var vc = EnterNameViewController<SelectEventLocationViewModel>()
        let viewModel = SelectEventLocationViewModel(coordinator: self)
        vc.setViewModelBinding(model: viewModel)
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


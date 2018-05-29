//
//  SubmissionDetailCoordinator.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/29/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import UIKit

final class SubmissionDetailInfo {
    var submission: Submission?
    var selectedEvent: Event?
}

final class SubmissionDetailCoordinator {
    
    enum Screen: Int {
        case submissionDetail
        case addSubmissionToEvent
    }
    
    private var submissionDetailInfo = SubmissionDetailInfo()
    weak var navigationController: UINavigationController?
    let screens: [Screen]
    
    init(submission: Submission,
         navVc: UINavigationController,
         screens: [Screen]) {
        self.navigationController = navVc
        self.screens = screens
        self.submissionDetailInfo.submission = submission
        navVc.isNavigationBarHidden = true
    }
    
    func navigateTo(screen: Screen) {
        switch screen {
        case .submissionDetail: toSubmissionDetail()
        case .addSubmissionToEvent: toAddSubmissionEvent()
        }
    }
    
    func didSelectEvent(_ event: Event) {
        submissionDetailInfo.selectedEvent = event
        submissionDetailInfo.selectedEvent?.submissions.append(submissionDetailInfo.submission!)
    }
    
    //MARK: - Navigating
    private func toSubmissionDetail() {
        print("Going to submission detail screen!")
    }
    
    private func toAddSubmissionEvent() {
        print("Going to submission event screen!")
    }
    
    private func updateEvent() {
        //eventService.updateEvent(submissionDetailInfo.event!)
    }
}

//
//  EventDetailViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/29/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AdminEventDetailViewModel {
    
    //MARK: - Properties
    private let _event: Variable<Event>
    private let disposeBag = DisposeBag()
    private let coordinator: HomeCoordinator
    
    init(event: Event, coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self._event = Variable(event)
    }
    
    //MARK: - Outputs
    var displayedEvent: Observable<Event> {
        return _event.asObservable()
    }
    
    var displayedSubmissions: Observable<[Submission]> {
        return _event.asObservable().map { $0.submissions }
    }
    
    var actionButtonTitle: Observable<String> {
        return _event.asObservable().map { _ in "Send Invites" }
    }
    
    //MARK: - Inputs
    func bindSendInvitesButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: {
                self._event.value.submissions.forEach({ (sub) in
                    sub.allNumbers.forEach({ number in
                        print("Sending invite to: \(number)")
                    })
                })
            })
            .disposed(by: disposeBag)
    }
    
}

struct EventDetailViewModel {
    
    //MARK: - Properties
    private let _event: Variable<Event>
    private let disposeBag = DisposeBag()
    private let coordinator: HomeCoordinator
    
    init(event: Event, coordinator: HomeCoordinator) {
        self.coordinator = coordinator
        self._event = Variable(event)
    }
    
    //MARK: - Outputs
    var displayedEvent: Observable<Event> {
        return _event.asObservable()
    }
    
    var displayedSubmissions: Observable<[Submission]> {
        return _event.asObservable().map { $0.submissions }
    }
    
    var actionButtonTitle: Observable<String> {
        return _event.asObservable().map { _ in "Purchase Tickets" }
    }
    
    //MARK: - Inputs
    func bindPurchaseTicketsButton(_ observable: Observable<Void>) {
        observable
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { self.findCurrentUserSubmissionFor(event: self._event.value) }
            .filter { $0.purchasedTickets < $0.allNumbers.count }
            .subscribe(onNext: {
                print("user can still purchase \($0.allNumbers.count - $0.purchasedTickets)")
            })
            .disposed(by: disposeBag)
    }
    
}

extension EventDetailViewModel {
    private func findCurrentUserSubmissionFor(event: Event) -> Submission {
        return event.submissions.filter { $0.eventId! == event._id }.first!
    }
}

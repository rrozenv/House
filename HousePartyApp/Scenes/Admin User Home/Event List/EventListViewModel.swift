//
//  EventListViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol EventListInputsOutputs {
    var displayedEvents: Observable<[Event]> { get }
    func bindDidSelectEvent(_ observable: Observable<Event>)
}

struct EventListViewModel: EventListInputsOutputs {
    
    //MARK: - Properties
    private let _events = Variable<[Event]>([])
    private let disposeBag = DisposeBag()
    var selectedEvent = Variable<Event?>(nil)
    
    init(user: User) {
        _events.value = user.events
        bindUserDidUpdateNotification()
    }
    
    //MARK: - Outputs
    var displayedEvents: Observable<[Event]> {
        return _events.asObservable()
    }
    
    //MARK: - Inputs
    func bindDidSelectEvent(_ observable: Observable<Event>) {
        observable
            .bind(to: selectedEvent)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper Methods
    private func bindUserDidUpdateNotification() {
        NotificationCenter.default.rx.notification(.userDidUpdate)
            .subscribe(onNext: { _ in
                self._events.value = AppController.shared.currentUser!.events
            })
            .disposed(by: disposeBag)
    }
}

struct AdminEventListViewModel: EventListInputsOutputs {
    
    //MARK: - Properties
    private let _events = Variable<[Event]>([])
    private let disposeBag = DisposeBag()
    
    init(user: User) {
        _events.value = user.events
        bindUserDidUpdateNotification()
    }
    
    //MARK: - Outputs
    var displayedEvents: Observable<[Event]> {
        return _events.asObservable()
    }
    
    //MARK: - Inputs
    func bindDidSelectEvent(_ observable: Observable<Event>) {
        observable
            .subscribe(onNext: { print("Submission selected: \($0.date)") })
            .disposed(by: disposeBag)
    }
    
    //MARK: - Helper Methods
    private func bindUserDidUpdateNotification() {
        NotificationCenter.default.rx.notification(.userDidUpdate)
            .subscribe(onNext: { _ in
                self._events.value = AppController.shared.currentUser!.events
            })
            .disposed(by: disposeBag)
    }
}

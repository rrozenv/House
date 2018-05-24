//
//  SelectSquadViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct ContactViewModel: Queryable {
    let contact: Contact
    var isSelected: Bool
    
    var uniqueId: String {
        return contact.id
    }
    
    var filterById: String {
        return "\(contact.firstName) \(contact.lastName)"
    }
}

struct SelectSquadViewModel {
    
    //MARK: - Properties
    private let contacts = Variable<[ContactViewModel]>([])
    private var contactsAccessAuthorized = Variable(false)
    private let disposeBag = DisposeBag()
    private let contactStore: ContactsStore
   // private let coordinator: SignUpFlowCoordinator
    
    init(contactStore: ContactsStore = ContactsStore()) {
        self.contactStore = contactStore
        contactStore.isAuthorized()
            .bind(to: contactsAccessAuthorized)
            .disposed(by: disposeBag)
    }
    
    //MARK: - Outputs
    var hasAccessToContacts: Observable<Bool> {
        return contactsAccessAuthorized.asObservable().share()
    }
    
    var userContacts: Observable<[ContactViewModel]> {
        return contacts.asObservable()
    }
    
    //MARK: - Inputs
    func fetchContacts() {
        self.contactStore.userContacts()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .map { self.mapContactsToViewModels($0) }
            .bind(to: contacts)
            .disposed(by: disposeBag)
    }
    
    func bindDidSelectEnableContacts(_ observable: Observable<Void>) {
        observable
            .flatMap { self.contactStore.requestAccess() }
            .filter { $0 }
            .do(onNext: { self.contactsAccessAuthorized.value = $0 })
            .observeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .flatMap { _ in self.contactStore.userContacts() }
            .map { self.mapContactsToViewModels($0) }
            .bind(to: contacts)
            .disposed(by: disposeBag)
    }
    
//    func bindBackButton(_ observable: Observable<Void>) {
//        observable
//            .subscribe(onNext: { self.coordinator.toPreviousScreen() })
//            .disposed(by: disposeBag)
//    }
}

extension SelectSquadViewModel {
    private func mapContactsToViewModels(_ contacts: [Contact]) -> [ContactViewModel] {
        return contacts.map { ContactViewModel(contact: $0, isSelected: false) }
    }
}



//
//  SquadDescriptionViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SquadDescriptionViewModel {
    
    //MARK: - Properties
    private let _selectedContacts = Variable<[Contact]>([])
    private let disposeBag = DisposeBag()
    private let coordinator: CreateSubmissionCoordinator
    
    init(selectedContacts: [Contact], coordinator: CreateSubmissionCoordinator) {
        self._selectedContacts.value = selectedContacts
        self.coordinator = coordinator
    }
    
    //MARK: - Outputs
    var selectedContacts: Observable<[Contact]> {
        return _selectedContacts.asObservable()
    }
    
    //MARK: - Inputs
    func fetchContacts() {

    }
    
    func bindDidSelectEnableContacts(_ observable: Observable<Void>) {

    }

}

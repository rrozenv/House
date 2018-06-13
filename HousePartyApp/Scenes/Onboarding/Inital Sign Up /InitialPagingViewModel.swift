//
//  InitialPagingViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 6/13/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct InitialPagingViewModel {
    
    //MARK: - Properties
    private let cities = Variable<[String]>(Constants.availableCities)
    private let disposeBag = DisposeBag()
    let coordinator: SignUpFlowCoordinator
    
    init(coordinator: SignUpFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    //MARK: - Outputs
    var displayedCities: Observable<[String]> {
        return cities.asObservable()
    }
    
    //MARK: - Inputs
    func bindSearchText(_ observable: Observable<String>) {
        observable
            .subscribe(onNext: { searchText in
                guard searchText.isNotEmpty else {
                    self.cities.value = Constants.availableCities
                    return
                }
                self.cities.value = Constants.availableCities.filter { $0.contains(searchText) }
            })
            .disposed(by: disposeBag)
    }
    
    func bindClearSearch(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: {
                self.cities.value = Constants.availableCities
            })
            .disposed(by: disposeBag)
    }
    
    func bindDidSelectCity(_ observable: Observable<String>) {
        observable
            .subscribe(onNext: { self.coordinator.saveCity($0) })
            .disposed(by: disposeBag)
    }
    
    func bindBackButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.coordinator.toPreviousScreen() })
            .disposed(by: disposeBag)
    }
}

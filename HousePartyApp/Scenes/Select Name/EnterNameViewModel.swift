//
//  EnterNameViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/23/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct EnterNameViewModel {
    
    enum NameType {
        case first, last
    }
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let coordinator: SignUpFlowCoordinator
    private let text = Variable("")
    private let nameType: NameType
    
    init(coordinator: SignUpFlowCoordinator, nameType: NameType) {
        self.coordinator = coordinator
        self.nameType = nameType
    }
    
    var isNextButtonEnabled: Driver<Bool> {
        return text.asDriver().map { $0.isNotEmpty }
    }
    
    //MARK: - Inputs
    func bindTextEntry(_ observable: Observable<String>) {
        observable
            .bind(to: text)
            .disposed(by: disposeBag)
    }
    
    func bindContinueButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: {
                self.coordinator.didSaveName(self.text.value, nameType: self.nameType)
            })
            .disposed(by: disposeBag)
    }
    
    func bindClearButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.text.value = "" })
            .disposed(by: disposeBag)
    }
    
    func bindBackButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.coordinator.toPreviousScreen() })
            .disposed(by: disposeBag)
    }
}

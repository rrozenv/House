//
//  PhoneEntryViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/11/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PhoneEntryViewModel {

    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let coordinator: SignUpFlowCoordinator
    private let numberText = Variable("")
    
    init(coordinator: SignUpFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    var formattedPhoneNumber: Driver<String> {
        return numberText.asDriver()
            .map { $0.phoneRepresentable() ?? $0 }
    }
    
    var isPhoneNumberValid: Driver<Bool> {
        return numberText.asDriver().map { $0.isPhoneNumber }
    }
    
    var titleHeaderText: Driver<VaryingFontInfo> {
        return Driver.of(
            VaryingFontInfo(originalText: "What's your PHONE NUMBER?", fontDict: ["What's your": FontBook.AvenirMedium.of(size: 14), "PHONE NUMBER?": FontBook.AvenirHeavy.of(size: 14)], fontColor: .black)
        )
    }
    
    //MARK: - Inputs
    func bindTextEntry(_ observable: Observable<String>) {
        observable
            .bind(to: numberText)
            .disposed(by: disposeBag)
    }
    
    func bindContinueButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: {
                self.coordinator.didSavePhoneNumber(self.numberText.value)
            })
            .disposed(by: disposeBag)
    }
    
    func bindClearButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.numberText.value = "" })
            .disposed(by: disposeBag)
    }
    
    func bindBackButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.coordinator.toPreviousScreen() })
            .disposed(by: disposeBag)
    }
}



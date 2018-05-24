//
//  PhoneVerificationViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct PhoneVerificationViewModel {
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let coordinator: SignUpFlowCoordinator
    private let verificationCodeText = Variable("")
    
    init(coordinator: SignUpFlowCoordinator) {
        self.coordinator = coordinator
    }
    
    var isCodeValid: Driver<Bool> {
        return verificationCodeText.asDriver().map { $0.count == 6 }
    }
    
    var titleHeaderText: Driver<VaryingFontInfo> {
        return Driver.of(
            VaryingFontInfo(originalText: "Enter VERIFICATION CODE...", fontDict: ["Enter": FontBook.AvenirMedium.of(size: 14), "VERIFICATION CODE...": FontBook.AvenirHeavy.of(size: 14)], fontColor: .black)
        )
    }
    
    //MARK: - Inputs
    func bindTextEntry(_ observable: Observable<String>) {
        observable
            .bind(to: verificationCodeText)
            .disposed(by: disposeBag)
    }
    
    func bindContinueButton(_ observable: Observable<Void>) {
        observable //TODO: API verify code
            .subscribe(onNext: {
                self.coordinator.didVerifyPhoneNumberCode()
            })
            .disposed(by: disposeBag)
    }
    
    func bindClearButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.verificationCodeText.value = "" })
            .disposed(by: disposeBag)
    }
    
    func bindBackButton(_ observable: Observable<Void>) {
        observable
            .subscribe(onNext: { self.coordinator.toPreviousScreen() })
            .disposed(by: disposeBag)
    }
}

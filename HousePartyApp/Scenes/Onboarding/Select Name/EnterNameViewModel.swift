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

protocol TextEntryable {
    var isNextButtonEnabled: Driver<Bool> { get }
    var titleHeaderText: Driver<VaryingFontInfo> { get }
    func bindTextEntry(_ observable: Observable<String>)
    func bindContinueButton(_ observable: Observable<Void>)
    func bindClearButton(_ observable: Observable<Void>)
    func bindBackButton(_ observable: Observable<Void>)
}

struct EnterNameViewModel: TextEntryable {
    
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
    
    var titleHeaderText: Driver<VaryingFontInfo> {
        return Observable.just(nameType)
            .map { self.createVaryingFontInfoFor(nameType: $0) }
            .asDriverOnErrorJustComplete()
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

extension EnterNameViewModel {
    private func createVaryingFontInfoFor(nameType: NameType) -> VaryingFontInfo {
        switch nameType {
        case .first:
            return VaryingFontInfo(originalText: "What's your FIRST NAME?", fontDict: ["What's your": FontBook.AvenirMedium.of(size: 14), "FIRST NAME?": FontBook.AvenirBlack.of(size: 15)], fontColor: .black)
        case .last:
            return VaryingFontInfo(originalText: "What's your LAST NAME?", fontDict: ["What's your": FontBook.AvenirMedium.of(size: 14), "LAST NAME?": FontBook.AvenirBlack.of(size: 15)], fontColor: .black)
        }
    }
}

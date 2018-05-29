//
//  SelectEventLocationViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/28/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct SelectEventLocationViewModel: TextEntryable {
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private let coordinator: CreateEventCoordinator
    private let text = Variable("")
    
    init(coordinator: CreateEventCoordinator) {
        self.coordinator = coordinator
    }
    
    var isNextButtonEnabled: Driver<Bool> {
        return text.asDriver().map { $0.isNotEmpty }
    }
    
    var titleHeaderText: Driver<VaryingFontInfo> {
        return Observable.of(self.createVaryingFontInfo())
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
                self.coordinator.saveSelectedLocation(self.text.value)
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

extension SelectEventLocationViewModel {
    private func createVaryingFontInfo() -> VaryingFontInfo {
        return VaryingFontInfo(originalText: "WHERE will this event be?", fontDict: ["will this event be?": FontBook.AvenirMedium.of(size: 14), "WHERE": FontBook.AvenirBlack.of(size: 15)], fontColor: .black)
    }
}


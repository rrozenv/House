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

final class PhoneEntryViewModel {
    
    let disposeBag = DisposeBag()
    
    let phoneInput: AnyObserver<String>
    let nextButtonTappedInput:  AnyObserver<Void>
    
    let inputIsValid: Driver<Bool>
    let mainText: Driver<(header: String, body: String)>
    
    init(router: SignUpFlowCoordinator) {
        
        //MARK: - Subjects
        let _phoneInput = PublishSubject<String>()
        let _nextButtonTappedInput = PublishSubject<Void>()
        
        //MARK: - Observers
        self.phoneInput = _phoneInput.asObserver()
        self.nextButtonTappedInput = _nextButtonTappedInput.asObserver()
        
        //MARK: - Observables
        let phoneInput$ = _phoneInput.asObservable().startWith("").share()
        let nextTappedObservable = _nextButtonTappedInput.asObservable()
        
        //MARK: - Outputs
        let header = "What’s your full name?"
        let body = "You will always be in charge of who to share your identitiy with."
        
        self.mainText = Driver.of( (header: header, body: body))
        self.inputIsValid = phoneInput$
            .map { $0.count > 6 }
            .asDriver(onErrorJustReturn: false)
        
        //MARK: - Routing
        nextTappedObservable
            .withLatestFrom(phoneInput$)
            .do(onNext: { router.didSavePhoneNumber($0) })
            .subscribe()
            .disposed(by: disposeBag)
    }
    
}

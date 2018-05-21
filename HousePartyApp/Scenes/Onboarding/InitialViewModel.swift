//
//  InitialViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/21/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class InitialViewModel {
    
    let disposeBag = DisposeBag()
    
    let pageInfo: Driver<OnboardingInfo>
    
    //MARK: - Init
    init(info: OnboardingInfo) {
        //MARK: - Outputs
        self.pageInfo = Observable.of(info)
            .asDriverOnErrorJustComplete()
    }
    
}

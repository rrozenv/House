//
//  UsersViewModel.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class UsersViewModel {
    
    let disposeBag = DisposeBag()
    
    //MARK: - Outputs
    let users: Observable<[User]>
    let activityIndicator: Driver<Bool>
    let errorTracker: Driver<Error>
    
    //MARK: - Init
    init(string: String, userService: UserService = UserService()) {
        
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        self.activityIndicator = activityIndicator.asDriver()
        self.errorTracker = errorTracker.asDriver()
        
        //MARK: - Outputs
        self.users = Observable.of(string)
            .flatMapLatest { _ in userService.allUsers() }
        
    }
    
}

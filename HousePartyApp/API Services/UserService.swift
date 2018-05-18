//
//  UserService.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import Moya
import RxSwift

struct UserService {
    
    let provider = MoyaProvider<API>()
    
    func allUsers() -> Observable<[User]> {
        return provider.rx
            .request(.allUsers).asObservable()
            .map(UserList.self)
            .map { $0.users }
    }
    
    func create(user: JSONDictionary) -> Observable<User> {
        return provider.rx
            .request(.createUser(user)).asObservable()
            .map(User.self)
    }

}

public extension ObservableType where E == Moya.Response {
    
    public func map<T>(to type: T.Type, using decoder: JSONDecoder = JSONDecoder()) -> Observable<T> where T: Swift.Decodable {
        return map {
            try $0.map(type, using: decoder)
        }
    }
    
    public func mapOptional<T>(to type: T.Type, using decoder: JSONDecoder = JSONDecoder()) -> Observable<T?> where T: Swift.Decodable {
        return flatMap { response -> Observable<T?> in
            do {
                return Observable.just(try response.map(to: type, using: decoder))
            } catch {
                return Observable.just(nil)
            }
        }
    }
    
}

public extension Moya.Response {
    
    public func map<T>(to type: T.Type, using decoder: JSONDecoder = JSONDecoder()) throws -> T where T: Swift.Decodable {
        let decoder = decoder
        return try decoder.decode(type, from: data)
    }
    
}


    



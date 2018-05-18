//
//  API.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation
import Moya

enum API {
    case allUsers
    case createUser(JSONDictionary)
}

extension API: TargetType {
    
    // 3:
    var baseURL: URL {
        switch self {
        case .allUsers, .createUser(_):
            return URL(string: Constants.baseURL)!
        }
    }
    
    // 4:
    var path: String {
        switch self {
        case .allUsers, .createUser(_):
            return "/users"
        }
    }
    
    // 5:
    var method: Moya.Method {
        switch self {
        case .allUsers: return .get
        case .createUser(_): return .post
        }
    }
    
    // 6:
    var parameters: [String: Any] {
        switch self {
        case .allUsers: return [:]
        case .createUser(let body): return body
        }
    }
    
    var headers: [String : String]? {
        return nil
    }
    
    // 7:
    var parameterEncoding: ParameterEncoding {
        switch self {
        case .allUsers, .createUser(_): return URLEncoding.default
        }
    }
    
    // 8:
    var sampleData: Data {
        return Data()
    }
    
    // 9:
    var task: Task {
        return .requestParameters(parameters: parameters, encoding: parameterEncoding)
    }
}

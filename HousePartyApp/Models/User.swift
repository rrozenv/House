//
//  User.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/6/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

typealias JSONDictionary = [String: Any]

struct UserList: Codable {
    let users: [User]
}

struct User: Codable, Invitable {
    let _id: String
    var isAdmin: Bool = false
    let fullName: String
    let birthDate: String
    let phonenumber: String
    var events: [Event] = []
    var submissons: [Submission] = []
}

extension User {
    
    init?(dictionary: JSONDictionary) {
        guard let id = dictionary["_id"] as? String,
            let fullName = dictionary["fullName"] as? String,
            let birthDate = dictionary["birthDate"] as? String,
            let phonenumber = dictionary["phonenumber"] as? String else { return nil }
        self._id = id
        self.fullName = fullName
        self.birthDate = birthDate
        self.phonenumber = phonenumber
    }
    
    init(fullName: String,
         birthDate: String,
         phoneNumber: String) {
        self._id = "\(0)"
        self.fullName = fullName
        self.birthDate = birthDate
        self.phonenumber = phoneNumber
    }
    
    func toJSON() -> JSONDictionary {
        return [
            "fullName": fullName,
            "birthDate": birthDate,
            "phoneNumber": phonenumber
        ]
    }
    
}

extension User {
    static func JSON(fullName: String,
                     birthDate: String,
                     phoneNumber: String) -> [String: Any] {
        return [
            "fullName": fullName,
            "birthDate": birthDate,
            "phoneNumber": phoneNumber
        ]
    }
}


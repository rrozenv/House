//
//  Contact.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/24/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

struct Contact {
    let id: String
    let firstName: String
    let lastName: String
    let primaryNumber: String?
    let numbers: [String]
}

extension Contact {
    var fullName: String {
        return firstName + " " + lastName
    }
}

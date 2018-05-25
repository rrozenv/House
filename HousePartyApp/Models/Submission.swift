//
//  Submission.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

enum SubmissonStatus: String, Codable {
    case pending, accepted, expired
}

struct Submission: Codable {
    let leader: User
    let registeredFriends: [User]
    let unregisteredFriends: [User]
    let allNumbers: [String]
    let createdAt: Date
    let status: SubmissonStatus
}

struct Event {
    let _id: Int
    let venueName: String
    let date: Date
    let attendees: [Submission]
}

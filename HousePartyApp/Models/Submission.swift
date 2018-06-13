//
//  Submission.swift
//  HousePartyApp
//
//  Created by Robert Rozenvasser on 5/25/18.
//  Copyright © 2018 Cluk Labs. All rights reserved.
//

import Foundation

enum SubmissonStatus: String, Codable {
    case pending, invited, accepted, declined, expired
}

struct InvitableUser: Codable, Invitable {
    let _id: String
    let fullName: String
    let phonenumber: String
}

struct Submission: Codable {
    var eventId: String?
    let leader: User
    let registeredFriends: [User]
    let unregisteredFriends: [InvitableUser]
    let allNumbers: [String]
    var createdAt: Date
    var status: SubmissonStatus
    var purchasedTickets: Int = 0
}

struct Event: Codable {
    let _id: String
    let venueName: String
    let date: Date
    var submissions: [Submission]
}

extension Event {
    var isCurrentUserAttending: Bool {
        return AppController.shared.currentUser!.events.contains(where: { $0._id == self._id })
    }
}

//
//  CurrentUser.swift
//  Course2FinalTask
//
//  Created by Ivan on 05.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

class CurrentUser: Codable {
    var id: String
    var username: String
    var fullName: String
    var avatar: String
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
}

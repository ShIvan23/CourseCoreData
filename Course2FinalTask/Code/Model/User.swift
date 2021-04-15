//
//  User.swift
//  Course2FinalTask
//
//  Created by Ivan on 16.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

final class User: Codable {
    var id: String
    var username: String
    var fullName: String
    var avatar: String
    var avatarData: Data?
    var currentUserFollowsThisUser: Bool
    var currentUserIsFollowedByThisUser: Bool
    var followsCount: Int
    var followedByCount: Int
    
    init(id: String = "", username: String = "", fullName: String = "", avatar: String = "", avatarData: Data? = Data(), currentUserFollowsThisUser: Bool = false, currentUserIsFollowedByThisUser: Bool = false, followsCount: Int = 0, followedByCount: Int = 0) {
        self.id = id
        self.username = username
        self.fullName = fullName
        self.avatar = avatar
        self.avatarData = avatarData
        self.currentUserFollowsThisUser = currentUserFollowsThisUser
        self.currentUserIsFollowedByThisUser = currentUserIsFollowedByThisUser
        self.followsCount = followsCount
        self.followedByCount = followedByCount
    }
}

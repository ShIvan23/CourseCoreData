//
//  ErrorManager.swift
//  Course2FinalTask
//
//  Created by Ivan on 05.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import Foundation

enum ErrorManager: String, Error {
    case unauthorized = "Unauthorized" // 401
    case offlineMode = "Offline Mode"
}

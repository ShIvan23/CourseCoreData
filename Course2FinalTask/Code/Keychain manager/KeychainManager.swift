//
//  KeychainManager.swift
//  Course2FinalTask
//
//  Created by Ivan on 09.03.2021.
//  Copyright © 2021 e-Legion. All rights reserved.
//

import Foundation

protocol KeychainProtocol {
    func saveToken(token: String, userName: String) -> Bool
    func readToken(userName: String) -> String?
    func deleteToken(userName: String) -> Bool
//    func readAllItems() -> [String : String]?
}

class KeychainManager: KeychainProtocol {
    
    // MARK: - Public Properties
    static var login: String? 
    
    // MARK: - Private Methods
    private func keychainQuery(userName: String? = nil) -> [String : AnyObject] {
        
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        
        if let userName = userName {
            query[kSecAttrAccount as String] = userName as AnyObject
        }
        
        return query
    }
    
    // MARK: - Public Methods
    func saveToken(token: String, userName: String) -> Bool {
        
        let tokenData = token.data(using: .utf8)
        
        if readToken(userName: userName) != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = tokenData as AnyObject
            
            let query = keychainQuery(userName: userName)
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = keychainQuery(userName: userName)
        item[kSecValueData as String] = tokenData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
    
    func readToken(userName: String) -> String? {
        
        var query = keychainQuery(userName: userName)
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
        
        if status != noErr {
            return nil
        }
        
        guard let item = queryResult as? [String : AnyObject],
              let tokenData = item[kSecValueData as String] as? Data,
              let token = String(data: tokenData, encoding: .utf8) else {
            return nil
        }
        
        return token
    }
    
    func deleteToken(userName: String) -> Bool {
        let item = keychainQuery(userName: userName)
        let status = SecItemDelete(item as CFDictionary)
        return status == noErr
    }
    
//    func readAllItems() -> [String : String]? {
//        var query = keychainQuery()
//        query[kSecMatchLimit as String] = kSecMatchLimitAll
//        query[kSecReturnData as String] = kCFBooleanTrue
//        query[kSecReturnAttributes as String] = kCFBooleanTrue
//
//        var queryResult: AnyObject?
//        let status = SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer(&queryResult))
//
//        if status != noErr {
//            return nil
//        }
//
//        guard let items = queryResult as? [[String : AnyObject]] else {
//            return nil
//        }
//
//        var tokenItems = [String : String]()
//
//        for (index, item) in items.enumerated() {
//            guard let tokenData = item[kSecValueData as String] as? Data,
//                  let token = String(data: tokenData, encoding: .utf8) else {
//                continue
//            }
//
//            if let account = item[kSecAttrAccount as String] as? String {
//                tokenItems[account] = token
//                continue
//            }
//
//            let account = "empty account \(index)"
//            tokenItems[account] = token
//        }
//
//        return tokenItems
//    }
    
    
}

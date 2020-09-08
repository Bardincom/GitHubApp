//
//  AuthenticationViewController extension.swift
//  GitHubApp
//
//  Created by Polina on 22.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import UIKit

class KeychainStorage {
    
    static let shared = KeychainStorage()
    private let service = "GitHubApp"
    
    private func keychainQuery() -> [String : AnyObject] {
        var query = [String : AnyObject]()
        query[kSecClass as String] = kSecClassGenericPassword
        query[kSecAttrAccessible as String] = kSecAttrAccessibleWhenUnlocked
        query[kSecAttrService as String] = service as AnyObject
        return query
    }
    
    public func readAnyAccount() -> Data? {
        var query = keychainQuery()
        query[kSecMatchLimit as String] = kSecMatchLimitOne
        query[kSecReturnData as String] = kCFBooleanTrue
        query[kSecReturnAttributes as String] = kCFBooleanTrue
        
        var queryResult: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &queryResult)
        
        if status != noErr {
            return nil
        }
        guard let item = queryResult as? [String : AnyObject],
            let accountData = item[kSecValueData as String] as? Data else {
                return nil
        }
        return accountData
    }
    
    public func saveAccount(account: Account) -> Bool {
        let encoder = JSONEncoder()
        let accountData = try? encoder.encode(account)
        
        if readAnyAccount() != nil {
            var attributesToUpdate = [String : AnyObject]()
            attributesToUpdate[kSecValueData as String] = accountData as AnyObject
            
            let query = keychainQuery()
            let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
            return status == noErr
        }
        
        var item = keychainQuery()
        item[kSecValueData as String] = accountData as AnyObject
        let status = SecItemAdd(item as CFDictionary, nil)
        return status == noErr
    }
}


//
//  Account.swift
//  GitHubApp
//
//  Created by Polina on 17.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation

struct Account: Codable {
    var username: String
    var password: String
    
    func codeInfo() -> String {
        guard let result = "\(username):\(password)".data(using: .utf8)?.base64EncodedString() else { return "" }
        return result
    }
}

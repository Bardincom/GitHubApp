//
//  Owner.swift
//  GitHubApp
//
//  Created by Polina on 17.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation

struct Owner: Codable {
    var login: String?
    var avatarURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case login = "login"
    }
}

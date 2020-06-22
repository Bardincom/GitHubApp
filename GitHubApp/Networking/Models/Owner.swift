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
        // логин будет по дефолту, можно не задавать ему ключ
        case login = "login"
        case avatarURL = "avatar_url"
    }
}

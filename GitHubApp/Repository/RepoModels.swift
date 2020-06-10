//
//  RepoModels.swift
//  GitHubApp
//
//  Created by Polina on 11.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation

struct Repository: Codable {
    var name: String?
    var description: String?
    var htmlURL: String?
    var owner: Owner?
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case description = "description"
        case owner = "owner"
        case htmlURL = "html_url"
    }
}

struct Owner: Codable {
    var login: String?
    var avatarURL: URL?
    
    enum CodingKeys: String, CodingKey {
        case login = "login"
        case avatarURL = "avatar_url"
    }
}

struct repoSearch: Codable {
    var repositories: [Repository]?
    
    enum CodingKeys: String, CodingKey {
        case repositories = "items"
    }
}

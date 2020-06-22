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
        // все кейсы, кроме htmlURL будут такими по дефолту, поэтому можно удалить из этого перечисления
        case name = "name"
        case description = "description"
        case owner = "owner"
        case htmlURL = "html_url"
    }
}

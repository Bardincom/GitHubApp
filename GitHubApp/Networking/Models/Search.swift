//
//  Search.swift
//  GitHubApp
//
//  Created by Polina on 17.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation

struct Search: Codable {
    var repositories: [Repository]?
    
    enum CodingKeys: String, CodingKey {
        // почему бы не оставить айтемс, тогда не придется создавать это перечисление
        case repositories = "items"
    }
}

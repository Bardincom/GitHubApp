//
//  ProfileViewController Extension.swift
//  GitHubApp
//
//  Created by Polina on 01.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension ProfileViewController {
    
    func searchRepo() {
        let sharedSession = URLSession.shared
        let repository = repositoryText.text
        let language = languageText.text
        var filter = "ascended"
        
        if segmentView.selectedSegmentIndex == 1 {
            filter = "descended"
        }
        
        guard let url = URL(string:
            "https://api.github.com/search/repositories?q=\(repository ?? "")+language:\(language ?? "")&sort=stars&order=\(filter)")
            else { return }
        
        let request = URLRequest(url: url)
        
        let dataTask = sharedSession.dataTask(with: request) { (data, respons, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            guard let text = String(data: data, encoding: .utf8) else { return }
            print(text)
        }
        dataTask.resume()
    }
}


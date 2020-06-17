//
//  AuthenticationViewController extension.swift
//  GitHubApp
//
//  Created by Polina on 17.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension AuthenticationViewController {
    
    func singIn() {
        
        let repoSearchController = RepositorySearchController()
        
        guard let baseURL = URL(string: "https://api.github.com/user") else { return }
        
        guard let username = loginText.text, let password = passwordText.text else { return }
        
        let info = Account(username: username, password: password)
        
        var request = URLRequest (url: baseURL)
        request.httpMethod = "GET"
        
        request.addValue("Basic \(info.codeInfo())", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) {
            (data, response, error) in
            
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    self.showAlert()
                    print("Error! HTTP status code: \(httpResponse.statusCode)")
                    return
                }
            }
            
            guard let data = data else { return }
            
            do {
                let loginRepo = try JSONDecoder().decode(Owner.self, from: data)
                guard let login = loginRepo.login, let avatarURL = loginRepo.avatarURL else { return }
                
                DispatchQueue.main.async {
                    repoSearchController.username = login
                    repoSearchController.avatarURL = avatarURL
                    self.loginButton.isEnabled = false
                    self.navigationController?.pushViewController(repoSearchController, animated:  false)
                }
                
            } catch let error {
                print(error)
            }
        }
        dataTask.resume()
    }
    
    private func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Invalid login or password", message: "Please, enter correct login and password", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

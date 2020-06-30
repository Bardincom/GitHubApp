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
import LocalAuthentication

extension AuthenticationViewController {
    
    func singIn() {
        
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
                    print("\(username),\(password)" )
                    return
                } else {
                    print("ok")
                    let result = self.keychain.saveAccount(account: info)
                    
                    if result, let savedPassword = self.keychain.readAnyAccount() {
                        print("added to Keychain \(username): \(password) // \(savedPassword)")
                    } else {
                        print("can't save password")
                    }
                }
            }
            guard let data = data else { return }
            
            do {
                let loginRepo = try JSONDecoder().decode(Owner.self, from: data)
                guard let login = loginRepo.login, let avatarURL = loginRepo.avatarURL else { return }
                
                DispatchQueue.main.async {
                    let repoSearchController = RepositorySearchController()
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
    
    func singInByBio(_ sender: Account) {
        
        var usname: String?
        var pass: String?
        
        usname = sender.username
        pass = sender.password
        
        guard let baseURL = URL(string: "https://api.github.com/user") else { return }
        
        guard let username = usname, let password = pass else { return }
        
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
                    let repoSearchController = RepositorySearchController()
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
    
    func authenticateUser(account: Account) {
        if #available(iOS 8.0, *, *) {
            let authenticationContext = LAContext()
            setupAuthenticationContext(context: authenticationContext)
            
            let reason = "Fast and safe authentication in your app"
            var authError: NSError?
            
            if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                    [unowned self] success, evaluateError in
                    if success {
                        self.singInByBio(account)
                    } else {
                        if let error = evaluateError {
                            print(error.localizedDescription)
                        }
                    }
                }
            } else {
                
                if let error = authError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = "Use for fast and safe authentication in your app"
        context.localizedCancelTitle = "Cancel"
        context.localizedFallbackTitle = "Enter password"
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
}

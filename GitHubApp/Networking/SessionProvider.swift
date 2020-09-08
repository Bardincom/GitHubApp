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

enum Result<T> {
    case success(T)
    case fail(Error)
}

enum statusCodeError: Error {
    case reason(reason: String)
}

final class SessionProvider  {
    
    static let shared = SessionProvider()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    
    func signIn(username: String, password: String, completionHandler: @escaping (Result<Owner>) -> Void) {
        guard let url = URL(string: Link.apiGitHub) else { print("url is empty"); return }
        let account = Account(username: username, password: password)
        var request = URLRequest(url: url)
        request.addValue("Basic \(account.codeInfo())", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    let error = statusCodeError.reason(reason: "httpstatus code \(httpResponse.statusCode) - Unauthorized")
                    completionHandler(.fail(error))
                    return
                }
            }
            
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(Owner.self, from: data)
                completionHandler(.success(user))
            } catch let error {
                completionHandler(.fail(error))
            }
        }
        dataTask.resume()
    }
    
    func singInByBio(_ sender: Account, completionHandler: @escaping (Result<Owner>) -> Void) {
        guard let url = URL(string: Link.apiGitHub) else { print("url is empty"); return }
        
        var usname: String?
        var pass: String?
        usname = sender.username
        pass = sender.password
        
        guard let username = usname, let password = pass else { return }
        let account = Account(username: username, password: password)
        var request = URLRequest(url: url)
        request.addValue("Basic \(account.codeInfo())", forHTTPHeaderField: "Authorization")
        
        let dataTask = URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 401 {
                    
                    let error = statusCodeError.reason(reason: "httpstatus code \(httpResponse.statusCode) - Unauthorized")
                    completionHandler(.fail(error))
                    return
                } else {
                    let result = KeychainStorage.shared.saveAccount(account: account)
                    if result, let savedPassword = KeychainStorage.shared.readAnyAccount() {
                        print("added to Keychain \(username): \(password) // \(savedPassword)")
                    } else {
                        print("can't save password")
                    }
                }
            }
            guard let data = data else { return }
            
            do {
                let user = try self.decoder.decode(Owner.self, from: data)
                DispatchQueue.main.async {
                    completionHandler(.success(user))
                }
            } catch {
                completionHandler(.fail(error))
            }
        }
        dataTask.resume()
    }
    
    func searchRepo(repository: String?,
                    language: String?,
                    filter: String?,
                    completionHandler: @escaping ([Repository]) -> Void) {
        
        guard let url = URL(string:
            "https://api.github.com/search/repositories?q=\(repository ?? "")+language:\(language ?? "")&sort=stars&order=\(filter ?? "")")
            else { return }
        
        let request = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let data = data else { return }
            
            do {
                let search = try self.decoder.decode(Search.self, from: data)
                guard let repositories = search.repositories else { return }
                DispatchQueue.main.async {
                    completionHandler(repositories)
                }
                
            } catch let error {
                print("Error", error)
            }
        }
        dataTask.resume()
    }
}

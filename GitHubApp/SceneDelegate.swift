//
//  SceneDelegate.swift
//  GitHubApp
//
//  Created by Polina on 17.05.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?
  var navigationController = UINavigationController()
    
 func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        let viewController = AuthenticationViewController()
        self.navigationController = UINavigationController(rootViewController: viewController)
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.rootViewController = self.navigationController
        
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let viewController = AuthenticationViewController()
            let navigationController = UINavigationController(rootViewController: viewController)
            
            window.rootViewController = navigationController
            
            self.window = window
            window.backgroundColor = UIColor.white
            window.makeKeyAndVisible()
        }
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
}


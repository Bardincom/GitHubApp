//
//  AuthenticationViewController.swift
//  
//
//  Created by Polina on 19.05.2020.
//

import Foundation
import UIKit
import SnapKit

class AuthenticationViewController: UIViewController {
    
    let logoImage: UIImageView = {
        let logoImage = UIImageView(frame: CGRect(x: 40, y: 125, width: 290, height: 120))
        logoImage.backgroundColor = .blue
        return logoImage
    }()
    
    let loginTextView: UITextView = {
        let loginTextView = UITextView(frame: CGRect(x: 60, y: 330, width: 250, height: 30))
        loginTextView.layer.borderWidth = 1
        loginTextView.layer.borderColor = UIColor.gray.cgColor
        loginTextView.text = "username"
        return loginTextView
    }()
    
    let passwordTextView: UITextView = {
        let passwordTextView = UITextView(frame: CGRect(x: 60, y: 380, width: 250, height: 30))
        passwordTextView.layer.borderWidth = 1
        passwordTextView.layer.borderColor = UIColor.gray.cgColor
        passwordTextView.text = "password"
        return passwordTextView
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.sizeToFit()
        
        return button
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        
  }
    
    private func addSubviews() {
        self.view.addSubview(logoImage)
        self.view.addSubview(loginTextView)
        self.view.addSubview(passwordTextView)
        self.view.addSubview(loginButton)
    }
    
    //    private func setupLayout() {
    //        logoImage.snp.makeConstraints{
    //
    //        }
    //
    //    }
    
}

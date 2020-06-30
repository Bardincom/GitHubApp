//
//  AuthenticationViewController.swift
//  
//
//  Created by Polina on 19.05.2020.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    let keychain = KeychainStorage()

    private let logoImage: UIImageView = {
        let gitUrl = URL(string: "https://mainacademy.ua/wp-content/uploads/2019/02/github-logo.png")
        let logoImage = UIImageView()
        logoImage.kf.setImage(with: gitUrl)
        
        return logoImage
    }()
    
    let loginText: UITextField = {
        let loginText = UITextField()
        loginText.layer.borderWidth = 1
        loginText.layer.borderColor = UIColor.gray.cgColor
        loginText.layer.cornerRadius = 6
        loginText.attributedPlaceholder = NSAttributedString(string: "username",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginText.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: loginText.frame.height))
        loginText.leftViewMode = .always
        loginText.font = UIFont(name: avenirFont,
                                size: 20)
        loginText.autocorrectionType = .no
        loginText.clearsOnBeginEditing = true
        
        return loginText
    }()
    
    let passwordText: UITextField = {
        let passwordText = UITextField()
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.gray.cgColor
        passwordText.layer.cornerRadius = 6
        passwordText.attributedPlaceholder = NSAttributedString(string: "password",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 10,
                                                     height: passwordText.frame.height))
        passwordText.leftViewMode = .always
        passwordText.font = UIFont(name: avenirFont, size: 20)
        passwordText.autocorrectionType = .no
        passwordText.isSecureTextEntry = true
        passwordText.clearsOnBeginEditing = true
        
        return passwordText
    }()
    
     let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.titleLabel?.font = UIFont(name: avenirFont, size: 20)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(switchToProfileViewController(parametrSender:)), for: .touchUpInside)
        
        return button
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.height <= screenheight {
            setKeyboardNotification()
        }
        
        addSubviews()
        setupLayout()
        self.passwordText.delegate = self
        self.loginText.delegate = self
        
        setloginButton(enabled: false)
                
        passwordText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
        let gestureView = UITapGestureRecognizer(target: self, action: #selector(tapRootView(_:)))
        view.addGestureRecognizer(gestureView)

       
        if let jsonData = keychain.readAnyAccount() {
                   let decoder = JSONDecoder()
            guard let account = (try? decoder.decode(Account.self, from: jsonData)) else { return }
         
                authenticateUser(account: account)
        }
        
    }
    
    func setKeyboardNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if view.frame.origin.y == .zero {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != .zero {
            view.frame.origin.y = .zero
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @objc func tapRootView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @objc func switchToProfileViewController(parametrSender: Any) {
        singIn()
   }
    
    private func setloginButton(enabled: Bool) {
          if enabled {
              loginButton.alpha = 1.0
              loginButton.isEnabled = true
          } else {
              loginButton.alpha = 0.5
              loginButton.isEnabled = false
          }
      }
    
    @objc private func textFieldChanged() {
         guard let repo = loginText.text, let lang = passwordText.text else { return }
         let formFilled = !(repo.isEmpty) && !(lang.isEmpty)
         setloginButton(enabled: formFilled)
     }
}

extension AuthenticationViewController {
    
    private func addSubviews() {
        self.view.addSubview(logoImage)
        self.view.addSubview(loginText)
        self.view.addSubview(passwordText)
        self.view.addSubview(loginButton)
    }
    
    private func setupLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(logoTopOffset)
            $0.leading.equalToSuperview().offset(logoLeftOffset)
            $0.trailing.equalToSuperview().offset(logoRightOffset)
            $0.height.equalTo(logoHeight)
        }
        
        loginText.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(logoBottomOffset)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(textFieldHeight)
        }
        
        passwordText.snp.makeConstraints {
            $0.top.equalTo(loginText.snp.bottom).offset(loginTextFieldBottomOffset)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(textFieldHeight)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordText.snp.bottom).offset(passwordTextFieldBottomOffset)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(buttonHeight)
        }
    }
}



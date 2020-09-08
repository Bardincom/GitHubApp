//
//  AuthenticationViewController.swift
//  
//
//  Created by Polina on 19.05.2020.
//

import UIKit
import SnapKit
import Kingfisher
import LocalAuthentication

final class AuthenticationViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Setup UI elements
    
    private let logoImage: UIImageView = {
        let gitUrl = URL(string: Link.imageLogo)
        let logoImage = UIImageView()
        logoImage.kf.setImage(with: gitUrl)
        return logoImage
    }()
    
    let loginText: UITextField = {
        let loginText = UITextField()
        loginText.layer.borderWidth = 1
        loginText.layer.borderColor = UIColor.gray.cgColor
        loginText.layer.cornerRadius = 6
        loginText.attributedPlaceholder = NSAttributedString(string: Name.userName,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginText.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: loginText.frame.height))
        loginText.leftViewMode = .always
        loginText.font = UIFont(name: Font.avenir,
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
        passwordText.attributedPlaceholder = NSAttributedString(string: Name.password,
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 10,
                                                     height: passwordText.frame.height))
        passwordText.leftViewMode = .always
        passwordText.font = UIFont(name: Font.avenir, size: 20)
        passwordText.autocorrectionType = .no
        passwordText.isSecureTextEntry = true
        passwordText.clearsOnBeginEditing = true
        return passwordText
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.login, for: .normal)
        button.titleLabel?.font = UIFont(name: Font.avenir, size: 20)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(switchToProfileViewController(parametrSender:)), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cyrcle
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardNotification()
        addSubviews()
        setupLayout()
        setupTextFieldSettings()
        setloginButton(enabled: false)
        setupBioAuthenticationSettings()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc private func textFieldChanged() {
        guard let repo = loginText.text, let lang = passwordText.text else { return }
        let formFilled = !(repo.isEmpty) && !(lang.isEmpty)
        setloginButton(enabled: formFilled)
    }
    
    // MARK: - Authentication
    
    @objc func switchToProfileViewController(parametrSender: Any) {
        let repoSearchController = RepositorySearchController()
        self.loginButton.isEnabled = false
        guard let username = loginText.text,
              let password = passwordText.text else { return }
        
        SessionProvider.shared.signIn(username: username, password: password) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    repoSearchController.username = user.login
                    repoSearchController.avatarURL = user.avatarURL
                    self?.navigationController?.pushViewController(repoSearchController, animated: false)
                 }
            case .fail( _):
                self?.showAlert()
            }
        }
    }
    
    private func authenticateUser(account: Account) {
        let authenticationContext = LAContext()
        setupAuthenticationContext(context: authenticationContext)
        let reason = "Fast and safe authentication in your app"
        var authError: NSError?
        
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
            authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
                [unowned self] success, evaluateError in
                if success {
                    DispatchQueue.main.async {
                        let repoSearchController = RepositorySearchController()
                        
                        SessionProvider.shared.singInByBio(account) { [weak self] result in
                            guard let self = self else { return }
                            switch result {
                            case .success(let user):
                                DispatchQueue.main.async {
                                    repoSearchController.username = user.login
                                    repoSearchController.avatarURL = user.avatarURL
                                    self.navigationController?.pushViewController(repoSearchController, animated: false)
                                }
                            case .fail( _):
                                print("error")
                            }
                        }
                    }
                } else {
                    guard let error = evaluateError else { return }
                    print(error.localizedDescription)
                }
            }
        } else {
            guard let error = authError  else { return }
            print(error.localizedDescription)
        }
    }
    
    private func setupBioAuthenticationSettings() {
        if let jsonData = KeychainStorage.shared.readAnyAccount() {
            let decoder = JSONDecoder()
            guard let account = (try? decoder.decode(Account.self, from: jsonData)) else { return }
            authenticateUser(account: account)
        }
    }
    
    private func setupAuthenticationContext(context: LAContext) {
        context.localizedReason = Context.localizedReason
        context.localizedCancelTitle = Context.localizedCancelTitle
        context.localizedFallbackTitle = Context.localizedFallbackTitle
        context.touchIDAuthenticationAllowableReuseDuration = 600
    }
    
    private func showAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: Alert.title, message: Alert.messege, preferredStyle: .alert)
            let okAction = UIAlertAction(title: Alert.ok, style: .default)
            
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
}

// MARK: - UI Settings

extension AuthenticationViewController {
    
    private func setloginButton(enabled: Bool) {
        if enabled {
            loginButton.alpha = 1.0
            loginButton.isEnabled = true
        } else {
            loginButton.alpha = 0.5
            loginButton.isEnabled = false
        }
    }
    
    private func setupTextFieldSettings() {
        self.passwordText.delegate = self
        self.loginText.delegate = self
        passwordText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        loginText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
    private func addSubviews() {
        self.view.addSubview(logoImage)
        self.view.addSubview(loginText)
        self.view.addSubview(passwordText)
        self.view.addSubview(loginButton)
    }
    
    private func setupLayout() {
        logoImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(190)
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().offset(-20)
            $0.height.equalTo(120)
        }
        
        loginText.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(50)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        passwordText.snp.makeConstraints {
            $0.top.equalTo(loginText.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(passwordText.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        }
    }
}



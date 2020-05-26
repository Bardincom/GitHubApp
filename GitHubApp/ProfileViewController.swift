//
//  ProfileViewController.swift
//
//
//  Created by Polina on 26.05.2020.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

final class ProfileViewController: UIViewController, UITextFieldDelegate  {
    
    private let logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.layer.cornerRadius = 65
        logoImage.clipsToBounds = true
        let gitUrl = URL(string: "https://beg.moscow/wp-content/uploads/2018/08/Avatar-300x300.png")
        logoImage.kf.setImage(with: gitUrl)
        
        
        return logoImage
    }()
    
    private let loginText: UITextField = {
        let loginText = UITextField()
        loginText.layer.borderWidth = 1
        loginText.layer.borderColor = UIColor.gray.cgColor
        loginText.layer.cornerRadius = 6
        loginText.attributedPlaceholder = NSAttributedString(string: "repository username",
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        loginText.leftView = UIView(frame: CGRect(x: 0,
                                                  y: 0,
                                                  width: 10,
                                                  height: loginText.frame.height))
        loginText.leftViewMode = .always
        loginText.font = UIFont(name: font,
                                size: 20)
        loginText.autocorrectionType = .no
        loginText.clearsOnBeginEditing = true
        
        return loginText
    }()
    
    private let passwordText: UITextField = {
        let passwordText = UITextField()
        passwordText.layer.borderWidth = 1
        passwordText.layer.borderColor = UIColor.gray.cgColor
        passwordText.layer.cornerRadius = 6
        passwordText.attributedPlaceholder = NSAttributedString(string: "language",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        passwordText.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 10,
                                                     height: passwordText.frame.height))
        passwordText.leftViewMode = .always
        passwordText.font = UIFont(name: font, size: 20)
        passwordText.autocorrectionType = .no
        passwordText.clearsOnBeginEditing = true
        
        return passwordText
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Hello!"
        label.textAlignment = .center
        label.font = UIFont(name: font, size: 35)
        label.numberOfLines = 1
        label.textColor = .black
        
        return label
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Search repository"
        label.textAlignment = .center
        label.font = UIFont(name: font, size: 30)
        label.numberOfLines = 1
        label.textColor = .black
        
        return label
    }()
    
    private let segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["ascended", "descended"])
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,
                                        NSAttributedString.Key.font: UIFont(name: font, size: 17) as Any], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                        NSAttributedString.Key.font: UIFont(name: font, size: 17) as Any], for: .normal)
        segment.backgroundColor = .lightGray
        
        segment.layer.cornerRadius = 5
        
        return segment
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start search", for: .normal)
        button.titleLabel?.font = UIFont(name: font, size: 20)
        button.backgroundColor = .black
        button.layer.cornerRadius = 6
        
        return button
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
setKeyboardNotification()
        
        addSubviews()
        setupLayout()
        self.passwordText.delegate = self
        self.loginText.delegate = self
        
        let gestureView = UITapGestureRecognizer(target: self, action: #selector(tapRootView(_:)))
        view.addGestureRecognizer(gestureView)
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
            if view.frame.origin.y == 0 {
                view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    @objc func tapRootView(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension ProfileViewController {
    
    private func addSubviews() {
        self.view.addSubview(helloLabel)
        self.view.addSubview(logoImage)
        self.view.addSubview(loginText)
        self.view.addSubview(passwordText)
        self.view.addSubview(searchButton)
        self.view.addSubview(searchLabel)
        self.view.addSubview(segmentView)
    }
    
    private func setupLayout() {
        helloLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.leading.equalToSuperview().offset(70)
            $0.trailing.equalToSuperview().offset(-70)
            $0.height.equalTo(40)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(helloLabel.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(122)
            $0.trailing.equalToSuperview().offset(-122)
            $0.height.equalTo(130)
        }
        
        searchLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.height.equalTo(40)
        }
        
        loginText.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(20)
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
        
        segmentView.snp.makeConstraints {
            $0.top.equalTo(passwordText.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(textFieldHeight)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(buttonHeight)
            
        }
        
    }
}

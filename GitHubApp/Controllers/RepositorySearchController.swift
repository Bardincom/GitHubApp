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

final class RepositorySearchController: UIViewController, UITextFieldDelegate  {
    
    var username: String?
    var avatarURL: URL!
    
    private let logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.layer.cornerRadius = logoImage.bounds.height / 2
        logoImage.clipsToBounds = true
        
        return logoImage
    }()
    
    let repositoryText: UITextField = {
        let repositoryText = UITextField()
        repositoryText.layer.borderWidth = 1
        repositoryText.layer.borderColor = UIColor.gray.cgColor
        repositoryText.layer.cornerRadius = 6
        repositoryText.attributedPlaceholder = NSAttributedString(string: "repository name",
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        repositoryText.leftView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: 10,
                                                       height: repositoryText.frame.height))
        repositoryText.leftViewMode = .always
        repositoryText.font = UIFont(name: avenirFont, size: 20)
        repositoryText.autocorrectionType = .no
        repositoryText.clearsOnBeginEditing = true
        
        return repositoryText
    }()
    
    let languageText: UITextField = {
        let languageText = UITextField()
        languageText.layer.borderWidth = 1
        languageText.layer.borderColor = UIColor.gray.cgColor
        languageText.layer.cornerRadius = 6
        languageText.attributedPlaceholder = NSAttributedString(string: "language",
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        languageText.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 10,
                                                     height: languageText.frame.height))
        languageText.leftViewMode = .always
        languageText.font = UIFont(name: avenirFont, size: 20)
        languageText.autocorrectionType = .no
        languageText.clearsOnBeginEditing = true
        
        return languageText
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Hello!"
        label.textAlignment = .center
        label.font = UIFont(name: avenirFont, size: 25)
        label.numberOfLines = 1
        label.textColor = .black
        
        return label
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = "Search repository:"
        label.textAlignment = .center
        label.font = UIFont(name: avenirFont, size: 28)
        label.numberOfLines = 1
        label.textColor = .black
        
        return label
    }()
    
    let segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["ascended", "descended"])
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,
                                        NSAttributedString.Key.font: UIFont(name: avenirFont, size: 17) as Any], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                        NSAttributedString.Key.font: UIFont(name: avenirFont, size: 17) as Any], for: .normal)
        segment.backgroundColor = .lightGray
        segment.layer.cornerRadius = 5
        segment.selectedSegmentIndex = 0
        
        return segment
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Start search", for: .normal)
        button.titleLabel?.font = UIFont(name: avenirFont, size: 20)
        button.backgroundColor = .black
        button.alpha = 0.5
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        
        return button
    }()
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        
        if UIScreen.main.bounds.size.height <= screenheight {
            setKeyboardNotification()
        }
        
        addSubviews()
        setupLayout()
        
        languageText.delegate = self
        repositoryText.delegate = self
        
        guard let username = username else { return }
        helloLabel.text = "Hello, \(username)!"
        logoImage.layer.cornerRadius = 55
        
        logoImage.kf.setImage(with: avatarURL)
        
        setSearchButton(enabled: false)
        
        repositoryText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        languageText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        
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
    
    @objc func tapSearchButton(parametrSender: Any) {
        searchRepo()
    }
    
    private func setSearchButton(enabled: Bool) {
        if enabled {
            searchButton.alpha = 1.0
            searchButton.isEnabled = true
        } else {
            searchButton.alpha = 0.5
            searchButton.isEnabled = false
        }
    }
    
    @objc private func textFieldChanged() {
        guard let repo = repositoryText.text, let lang = languageText.text else { return }
        let formFilled = !(repo.isEmpty) && !(lang.isEmpty)
        setSearchButton(enabled: formFilled)
    }
}

extension RepositorySearchController {
    
    private func addSubviews() {
        view.addSubview(helloLabel)
        view.addSubview(logoImage)
        view.addSubview(repositoryText)
        view.addSubview(languageText)
        view.addSubview(searchButton)
        view.addSubview(searchLabel)
        view.addSubview(segmentView)
    }
    
    private func setupLayout() {
        helloLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(110)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(40)
        }
        
        logoImage.snp.makeConstraints {
            $0.top.equalTo(helloLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
            $0.height.width.equalTo(110)
        }
        
        searchLabel.snp.makeConstraints {
            $0.top.equalTo(logoImage.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.height.equalTo(40)
        }
        
        repositoryText.snp.makeConstraints {
            $0.top.equalTo(searchLabel.snp.bottom).offset(10)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(textFieldHeight)
        }
        
        languageText.snp.makeConstraints {
            $0.top.equalTo(repositoryText.snp.bottom).offset(loginTextFieldBottomOffset)
            $0.leading.equalToSuperview().offset(leftOffset)
            $0.trailing.equalToSuperview().offset(rightOffset)
            $0.height.equalTo(textFieldHeight)
        }
        
        segmentView.snp.makeConstraints {
            $0.top.equalTo(languageText.snp.bottom).offset(20)
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

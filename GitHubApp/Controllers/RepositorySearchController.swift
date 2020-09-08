//
//  ProfileViewController.swift
//
//
//  Created by Polina on 26.05.2020.
//

import UIKit
import SnapKit
import Kingfisher

final class RepositorySearchController: UIViewController, UITextFieldDelegate  {
    
    var username: String?
    var avatarURL: URL!
    
    // MARK: - Setup UI elements
    
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
        repositoryText.attributedPlaceholder = NSAttributedString(string: Name.repositoryName,
                                                                  attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        repositoryText.leftView = UIView(frame: CGRect(x: 0,
                                                       y: 0,
                                                       width: 10,
                                                       height: repositoryText.frame.height))
        repositoryText.leftViewMode = .always
        repositoryText.font = UIFont(name: Font.avenir, size: 20)
        repositoryText.autocorrectionType = .no
        repositoryText.clearsOnBeginEditing = true
        return repositoryText
    }()
    
    let languageText: UITextField = {
        let languageText = UITextField()
        languageText.layer.borderWidth = 1
        languageText.layer.borderColor = UIColor.gray.cgColor
        languageText.layer.cornerRadius = 6
        languageText.attributedPlaceholder = NSAttributedString(string: Name.language,
                                                                attributes: [NSAttributedString.Key.foregroundColor: UIColor.gray])
        languageText.leftView = UIView(frame: CGRect(x: 0,
                                                     y: 0,
                                                     width: 10,
                                                     height: languageText.frame.height))
        languageText.leftViewMode = .always
        languageText.font = UIFont(name: Font.avenir, size: 20)
        languageText.autocorrectionType = .no
        languageText.clearsOnBeginEditing = true
        return languageText
    }()
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = Text.helloLabel
        label.textAlignment = .center
        label.font = UIFont(name: Font.avenir, size: 25)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    private let searchLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .white
        label.text = Text.searchLabel
        label.textAlignment = .center
        label.font = UIFont(name: Font.avenir, size: 28)
        label.numberOfLines = 1
        label.textColor = .black
        return label
    }()
    
    let segmentView: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["ascended", "descended"])
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black,
                                        NSAttributedString.Key.font: UIFont(name: Font.avenir, size: 17) as Any], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white,
                                        NSAttributedString.Key.font: UIFont(name: Font.avenir, size: 17) as Any], for: .normal)
        segment.backgroundColor = .lightGray
        segment.layer.cornerRadius = 5
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle(Text.searchButton, for: .normal)
        button.titleLabel?.font = UIFont(name: Font.avenir, size: 20)
        button.backgroundColor = .black
        button.alpha = 0.5
        button.layer.cornerRadius = 6
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        
        return button
    }()
    
    // MARK: - Life cyrcle
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        setKeyboardNotification()
        addSubviews()
        setupLayout()
        setSearchButton(enabled: false)
        setupTextFieldSettings()
    }
    
    // MARK: - Methods
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func tapSearchButton(parametrSender: Any) {
        let repoController = RepoTableViewController()
        guard let repository = repositoryText.text, let language = languageText.text else { return }
        var filter = "asc"
        if segmentView.selectedSegmentIndex == 0 {
            filter = "desc"
        }
        SessionProvider.shared.searchRepo(repository: repository, language: language, filter: filter)  { foundedRepository in
            DispatchQueue.main.async {
                repoController.repositories = foundedRepository
                self.navigationController?.pushViewController(repoController, animated:  false)
            }
        }
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
}

     // MARK: - UI Settings

extension RepositorySearchController {
    
    @objc private func textFieldChanged() {
        guard let repo = repositoryText.text, let lang = languageText.text else { return }
        let formFilled = !(repo.isEmpty) && !(lang.isEmpty)
        setSearchButton(enabled: formFilled)
    }
    
    private func setupUI() {
        guard let username = username else { return }
        helloLabel.text = "\(Text.helloLabel), \(username)!"
        logoImage.layer.cornerRadius = 55
        logoImage.kf.setImage(with: avatarURL)
    }
    
    private func setupTextFieldSettings() {
        languageText.delegate = self
        repositoryText.delegate = self
        repositoryText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        languageText.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
    }
    
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
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        languageText.snp.makeConstraints {
            $0.top.equalTo(repositoryText.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        segmentView.snp.makeConstraints {
            $0.top.equalTo(languageText.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(45)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(segmentView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(30)
            $0.trailing.equalToSuperview().offset(-30)
            $0.height.equalTo(50)
        } 
    }
}

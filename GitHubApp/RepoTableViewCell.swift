//
//  RepoTableViewCell.swift
//  GitHubApp
//
//  Created by Polina on 05.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit
import Kingfisher

class RepoTableViewCell: UITableViewCell {
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
       // image.backgroundColor = .green
        image.layer.cornerRadius = image.bounds.height / 2
        image.clipsToBounds = true
        let gitUrl = URL(string: "https://www.freepngimg.com/download/github/3-2-github-png-image.png")
        image.kf.setImage(with: gitUrl)
        
        return image
    }()
    
    private let repoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: avenirBoldFont, size: 19)
        label.text = "repoLabel"
        label.textColor = .black
        
        return label
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: avenirFont, size: 17)
        label.text = "userName"
        label.textColor = .black
        
        return label
    }()
    
    private let repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: avenirFont, size: 17)
        label.text = "here will be a description of the repository logolabel"
        label.numberOfLines = 4
        label.textColor = .black
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviews()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        addSubview(repoLabel)
        addSubview(avatarImage)
        addSubview(repoDescriptionLabel)
        addSubview(userName)
    }
    
    private func setupLayout() {
        repoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.top.equalTo(contentView)
            $0.bottom.equalTo(repoDescriptionLabel.snp.top).offset(12)
           // $0.trailing.equalTo(userName.snp.leading).offset(50)
        }
        
        repoDescriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(15)
            $0.bottom.equalTo(contentView)
            $0.trailing.equalTo(avatarImage.snp.leading).inset(50)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalTo(avatarImage.snp.top).offset(1)
        }
        
        avatarImage.snp.makeConstraints {
            $0.bottom.equalTo(contentView).inset(10)
            $0.trailing.equalToSuperview().inset(15)
            $0.height.width.equalTo(60)
 }
}
}





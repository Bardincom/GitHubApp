//
//  RepoTableViewCell.swift
//  
//
//  Created by Polina on 11.06.2020.
//

import UIKit
import Foundation
import SpriteKit
import Kingfisher

class RepoTableViewCell: UITableViewCell {
    
    private let avatarImage: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = image.bounds.height / 2
        
        return image
    }()
    
    private let repoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: avenirBoldFont, size: 17)
        label.textColor = .black
        
        return label
    }()
    
    private let userName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: avenirFont, size: 15)
        label.textColor = .black
        
        return label
    }()
    
    private let repoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: avenirFont, size: 16)
        label.numberOfLines = 3
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
    
    func configure(repo: Repository) {
        self.repoLabel.text = repo.name
        self.userName.text = repo.owner?.login
        self.repoDescriptionLabel.text = repo.description
        
        let avatarURL = repo.owner?.avatarURL
        avatarImage.layer.cornerRadius = bounds.height / 3.4
        avatarImage.kf.setImage(with: avatarURL)
    }
    
    private func setupLayout() {
        repoLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.top.equalTo(contentView).offset(5)
            $0.bottom.equalTo(repoDescriptionLabel.snp.top).offset(-1)
            $0.width.equalTo(200)
            $0.height.equalTo(25)
        }
        
        repoDescriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(20)
            $0.width.equalTo(260)
        }
        
        userName.snp.makeConstraints {
            $0.top.equalTo(contentView)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(avatarImage.snp.top).offset(1)
        }
        
        avatarImage.snp.makeConstraints {
            $0.bottom.equalTo(contentView).inset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.width.equalTo(60)
        }
    }
}

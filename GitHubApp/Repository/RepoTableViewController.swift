//
//  RepoTableViewController.swift
//  GitHubApp
//
//  Created by Polina on 05.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class RepoTableViewController: UIViewController {
    
    private let reuseIdentifier = "cellID"
    private let headerReuseIdentifier = "headerID"
    
    var repositories = [Repository]()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
    }
}

extension RepoTableViewController {
    private func addSubviews() {
        self.view.addSubview(tableView)
    }
}

extension RepoTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? RepoTableViewCell else { return RepoTableViewCell() }
        cell.configure(repo: repositories[indexPath.row])
        
        return cell
    }
}

extension RepoTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 0,
                                          width: self.tableView.frame.width - 10,
                                          height: 60))
        label.font = UIFont(name: avenirBoldFont, size: 21)
        label.text = "Repositories found: \(repositories.count) "
        
        view.addSubview(label)
        view.sizeToFit()
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}



//
//  RepoTableViewController.swift
//  GitHubApp
//
//  Created by Polina on 05.06.2020.
//  Copyright © 2020 SergeevaPolina. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class RepoTableViewController: UIViewController {
    
    private var spinner: UIActivityIndicatorView!
    var repositories = [Repository]()

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(RepoTableViewCell.self, forCellReuseIdentifier: Name.cellID)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.frame = view.frame
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
    }
    
    private func addSubviews() {
        view.addSubview(tableView)
    }
}

// MARK: - DataSource & Delegate

extension RepoTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repositories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: Name.cellID,
            for: indexPath
            ) as? RepoTableViewCell else { return RepoTableViewCell() }
        cell.configure(repo: repositories[indexPath.row])
        spinner?.stopAnimating()
        
        return cell
    }
}

extension RepoTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 0,
                                          width: tableView.frame.width - 10,
                                          height: 60))
        label.font = UIFont(name: Font.avenirBold, size: 21)
        label.text = "\(Text.repoFound) \(repositories.count) "
        
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
        let repoWebView = WKWebViewController()
        let cell = repositories[indexPath.row]
        repoWebView.repositoryURL = cell.htmlURL
        self.navigationController?.pushViewController(repoWebView, animated:  false)
    }
}



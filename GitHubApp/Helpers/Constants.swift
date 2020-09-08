//
//  Helpers.swift
//  
//
//  Created by Polina on 25.05.2020.
//

import UIKit

enum Size {
    static let screenheight: CGFloat = 667
}

enum Font {
    static let avenir = "AvenirNext-Medium"
    static let  avenirBold = "AvenirNext-Bold"
}

enum Name {
    static let cellID = "cellID"
    static let hieaderID = "headerID"
    static let repositoryName = "repository name"
    static let userName = "username"
    static let password = "password"
    static let language = "language"
}

enum Link {
    static let imageLogo = "https://mainacademy.ua/wp-content/uploads/2019/02/github-logo.png"
    static let apiGitHub = "https://api.github.com/user"
}

enum Text {
    static let helloLabel = "Hello"
    static let searchLabel = "Search repository:"
    static let searchButton = "Start search"
    static let login = "Login"
    static let repoFound = "Repositories found:"
}

enum Context {
    static let localizedReason = "Use for fast and safe authentication in your app"
    static let localizedCancelTitle = "Cancel"
    static let localizedFallbackTitle = "Enter password"
}

enum Alert {
    static let title = "Invalid login or password"
    static let messege = "Please, enter correct login and password"
    static let ok = "Ok"
}

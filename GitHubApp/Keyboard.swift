////
////  Keyboard.swift
////
////
////  Created by Polina on 26.05.2020.
////
//
//import Foundation
//import UIKit
//
//weak var delegate: UIViewController?
//
//func setKeyboardNotification() {
//      NotificationCenter.default.addObserver(delegate,
//                                             selector: #selector(keyboardWillShow),
//                                             name: UIResponder.keyboardWillShowNotification,
//                                             object: nil)
//      NotificationCenter.default.addObserver(delegate,
//                                             selector: #selector(keyboardWillHide),
//                                             name: UIResponder.keyboardWillHideNotification,
//                                             object: nil)
//
//  }
//
//  @objc func keyboardWillShow(notification: NSNotification) {
//      if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
//          if frame.origin.y == 0 {
//              view.frame.origin.y -= keyboardSize.height
//          }
//      }
//  }
//
//  @objc func keyboardWillHide(notification: NSNotification) {
//      if view.frame.origin.y != 0 {
//          view.frame.origin.y = 0
//      }
//  }
//
//  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//      view.endEditing(true)
//      return false
//  }
//
//  @objc func tapRootView(_ sender: UITapGestureRecognizer) {
//      view.endEditing(true)
//  }

//
//  logInManager.swift
//  ThePaper
//
//  Created by Gautier Billard on 29/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//
import UIKit
import Foundation
import Firebase

protocol LogInManagerDelegate {
    func didLogIn()
    func didSignUp()
}
extension LogInManagerDelegate {
    func didLogIn() {
        
    }
    func didSignUp() {
        
    }
}
class LogInManager {
    
    var email: String
    var password: String
    
    var delegate: LogInManagerDelegate?
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    func logInAccount() {
        
        
        Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
            if let e = error {
                print(e)
            } else {
                print("user successfully registered")
                
                self.delegate?.didLogIn()
                
                
            }
        }
        
    }
//    func logOutAccount() {
//        do {
//            try Auth.auth().signOut()
//            navigationController?.popToRootViewController(animated: true)
//            defaults.set(false, forKey: K.shared.loggedIn)
//        }catch{
//            print("\(#function) problem when logging out")
//        }
//    }
    func createAccount() {
        
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print(e)
            } else {
                print("user successfully registered")
                self.delegate?.didSignUp()
            }
        }
    }
    
}

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
    func didSendPasswordResetEmail()
    func didGetAnError(error: Error)
}
extension LogInManagerDelegate {
    func didLogIn() {
    }
    func didSignUp() {
    }
    func didSendPasswordResetEmail(){
    }
}
class LogInManager {
    
    var email: String?
    var password: String?
    
    var delegate: LogInManagerDelegate?
    
    convenience init(email: String, password: String) {
        self.init()
        self.email = email
        self.password = password
    }
    convenience init(email: String) {
        self.init()
        self.email = email
    }
    func logInAccount() {
        
        if let email = self.email, let password = self.password {
            Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                if let e = error {
                    print(e)
                    self.delegate?.didGetAnError(error: e)
                } else {
                    print("user successfully registered")
                    
                    self.delegate?.didLogIn()
                    
                }
            }
        }

    }
    func sendNewPasswordEmail() {
        
        if let email = self.email {
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let e = error {
                    self.delegate?.didGetAnError(error: e)
                }else{
                    self.delegate?.didSendPasswordResetEmail()
                }
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
        
        if let email = email, let password = password {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.delegate?.didGetAnError(error: e)
                    print(e)
                } else {
                    print("user successfully registered")
                    self.delegate?.didSignUp()
                }
            }
        }
    }
    
}

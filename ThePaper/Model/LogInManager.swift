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
    func didLogInSpecial(logInManager: LogInManager)
    func didSignUp()
    func didSendPasswordResetEmail()
    func didGetAnError(error: Error)
    func didDeleteAccount()
}
extension LogInManagerDelegate {
    func didLogIn() {
    }
    func didSignUp() {
    }
    func didSendPasswordResetEmail(){
    }
    func didDeleteAccount(){
    }
    func didLogInSpecial(logInManager: LogInManager){
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
                    self.delegate?.didLogInSpecial(logInManager: self)
                    
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
    func deleteAccount() {
        
        let user = Auth.auth().currentUser
        
        if let user = user {
            DataBaseManager.shared.cleanDataForCurrentUser {
                user.delete(completion: { (error) in
                    if let e = error {
                        print(e)
                    }else{
                        defaults.set(nil, forKey: K.shared.user)
                        self.delegate?.didDeleteAccount()
                    }
                })
            }
            
        }
        
    }
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

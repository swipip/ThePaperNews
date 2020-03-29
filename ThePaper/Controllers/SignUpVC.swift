//
//  SignUpVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 27/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {

    @IBOutlet weak var signButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.title = "The Paper"
        
        signButton.setUpButton()
        
        setUpTextField(textField: emailTextField)
        emailTextField.textContentType = .username
        setUpTextField(textField: passwordTextField)
        passwordTextField.textContentType = .password
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBar()
    }
    private func setUpNavBar() {
        
        let navBar                               = self.navigationController?.navigationBar
        navBar?.isHidden                         = false
        
    }
    func setUpTextField(textField: UITextField) {
        
        textField.borderStyle = .none
        textField.contentMode = .center
        textField.textColor = .white
        textField.tintColor = .white
        textField.delegate = self
        
        let backView = UIView()
        backView.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        backView.layer.cornerRadius = 25
        
        self.view.insertSubview(backView, at: 0)
        
        //view
        let fromView = backView
        //relative to
        let toView = textField
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 10),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
    }

    fileprivate func createAccount() {
        if let email = emailTextField.text, let password = passwordTextField.text{
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e)
                } else {
                    print("user successfully registered")
//                    self.performSegue(withIdentifier: "signUpToMain", sender: self)
                }
            }
        } else {
            print("missing authentication")
        }
    }
    
    @IBAction func buttonPressed(_ sender: UIButton!) {
        
        createAccount()
        
    }
}

extension SignUpVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        if textField == passwordTextField {
            
            createAccount()

        }
        return true
    }
    
}

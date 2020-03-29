//
//  SignInVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 29/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import Firebase

class SignInVC: UIViewController {

    //UI
    private var emailTextField:     UITextField!
    private var passwordTextField:  UITextField!
    private var signInButton:       UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "The Paper"

        
        setUpUI()
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setUpUI() {
        
        addEmailTextField()
        addPasswordTextField()
        addButton()
        
    }
    private func addButton() {
        
        signInButton = UIButton()
        signInButton.backgroundColor = UIColor(named: "mainColorTheme")
        signInButton.layer.cornerRadius = 25
        signInButton.setTitle("Sign In", for: .normal)
        signInButton.tintColor = .white
        signInButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        self.view.addSubview(signInButton)
                
        //view
        let fromView = signInButton!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.heightAnchor.constraint(equalToConstant: 50),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -100)])
        
    }
    private func addEmailTextField() {
        emailTextField = UITextField()
        emailTextField.backgroundColor = .lightGray
        
        self.view.addSubview(emailTextField)
        
        setTextFieldConstraints(textField: emailTextField ,topConstaint: 100)
        
    }
    private func addPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.backgroundColor = .lightGray
        
        self.view.addSubview(passwordTextField)
        
        setTextFieldConstraints(textField: passwordTextField ,topConstaint: 160)
        
    }
    private func setTextFieldConstraints(textField: UITextField,topConstaint: CGFloat) {
        //view
        let fromView = textField
        //relative to
        let toView = self.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: topConstaint),
                                     fromView.heightAnchor.constraint(equalToConstant: 50)])
    }
    @IBAction func buttonPressed(_ sender: Any) {
        
        let destinationVC = BaseNavigatorVC()
        self.navigationController?.pushViewController(destinationVC, animated: true)
        
    }
    private func logInAccount() {
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                    if let e = error {
                        print(e)
                    } else {
                        print("user successfully registered")
                        
                        let destinationVC = BaseNavigatorVC()
                        self.navigationController?.pushViewController(destinationVC, animated: true)
                        
    //                    self.performSegue(withIdentifier: "signInToMain", sender: self)
                    }
                }
            }
        }

}

//
//  SignInVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 29/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import Firebase

class SignUpVC: UIViewController {
    
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
    override func viewDidAppear(_ animated: Bool) {
        setBackgroundView(for: emailTextField)
        setBackgroundView(for: passwordTextField)
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
        signInButton.setUpButton()
        signInButton.setTitle("Sign Up", for: .normal)
        
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
        emailTextField.textColor = .white
        emailTextField.backgroundColor = .clear
        emailTextField.textAlignment = .center
        emailTextField.placeholder = "email address"
        emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
        
        setTextFieldConstraints(textField: emailTextField ,topConstaint: 150)
        
    }
    private func addPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.textColor = .white
        passwordTextField.backgroundColor = .clear
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "password"
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        self.view.addSubview(passwordTextField)
        
        setTextFieldConstraints(textField: passwordTextField ,topConstaint: 210)

    }
    private func setBackgroundView(for textField: UITextField) {
        
        let view = UIView()
        view.frame = textField.frame
        view.backgroundColor = K.shared.grayTextFieldBackground
        view.layer.cornerRadius = 6
        
        self.view.insertSubview(view, at: 0)
        
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
        
        createAccount()
        
    }
    private func createAccount() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            let logInManager = LogInManager(email: email, password: password)
            logInManager.createAccount()
            logInManager.delegate = self
        }

        
    }
    
}
extension SignUpVC: LogInManagerDelegate {
    func didSignUp() {
        let destinationVC = OnBoardingVC()
        destinationVC.delegate = self
        self.title = ""
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }

}
extension SignUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        createAccount()
        
        return true
    }
}
extension SignUpVC: OnBoardingVCDelegate {
    
    func didFinishChoosingPreferences(preferences: [String]) {
        let destinationVC = BaseNavigatorVC()
        self.navigationController?.pushViewController(destinationVC, animated: true)

        if let user = Auth.auth().currentUser {
            let uid:String = user.email!
            
            for preference in preferences {
                var ref: DocumentReference? = nil
                ref = db.collection("usersPreferences").addDocument(data: [
                    "user": uid,
                    "preference": preference,
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            }
  
        }
    }

}

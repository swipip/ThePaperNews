//
//  SignInVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 29/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class SignInVC: UIViewController {

    //UI
    private var emailTextField:         UITextField!
    private var passwordTextField:      UITextField!
    private var signInButton:           UIButton!
    private var resetPasswordButton:    UIButton!
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
        
        addForgetPassword()
    }
    private func addButton() {
        
        signInButton = UIButton()
        signInButton.setUpButton()
        signInButton.setTitle("Connexion", for: .normal)
        
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
        emailTextField.textContentType = .emailAddress
        emailTextField.textAlignment = .center
        emailTextField.placeholder = "Adresse e-mail"
        emailTextField.delegate = self
        
        self.view.addSubview(emailTextField)
        
        setTextFieldConstraints(textField: emailTextField ,topConstaint: 150)
        
    }
    private func addPasswordTextField() {
        passwordTextField = UITextField()
        passwordTextField.textColor = .white
        passwordTextField.backgroundColor = .clear
        passwordTextField.textAlignment = .center
        passwordTextField.placeholder = "Mot de passe"
        passwordTextField.textContentType = .password
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        
        self.view.addSubview(passwordTextField)
        
        setTextFieldConstraints(textField: passwordTextField ,topConstaint: 210)

    }
    private func addForgetPassword() {
        
        resetPasswordButton = UIButton()
        resetPasswordButton.setTitleColor(.lightGray, for: .normal)
        resetPasswordButton.setTitle("Mot de passe oublié", for: .normal)
        resetPasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        resetPasswordButton.layer.cornerRadius = 8
        
        self.view.addSubview(resetPasswordButton)
        
        //view
        let fromView = resetPasswordButton!
        //relative to
        let toView = passwordTextField!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 10),
                                     fromView.heightAnchor.constraint(equalToConstant: 40)])
        
        resetPasswordButton.addTarget(self, action: #selector(forgotPasswordPressed(_:)), for: .touchUpInside)
    }
    @IBAction private func forgotPasswordPressed(_ sender: UIButton!) {
        
        sender.isEnabled = false
        
        if emailTextField.text != "" {
            animatePasswordResetButton()
            let email = emailTextField.text!
            let logInManager = LogInManager(email: email)
            logInManager.delegate = self
            logInManager.sendNewPasswordEmail()
        }else{
            highlightMissingField(view: emailTextField)
        }

        
    }
    private func animatePasswordResetButton() {
        let feedbackView = UIView()
        feedbackView.frame = resetPasswordButton.frame
        feedbackView.layer.borderColor = UIColor.systemGreen.cgColor
        feedbackView.layer.borderWidth = 1
        feedbackView.layer.cornerRadius = 8
        
        self.view.insertSubview(feedbackView, at: 0)
        
        UIView.animate(withDuration: 0.2, delay: 0 ,animations: {
            feedbackView.backgroundColor = .systemGreen
            self.resetPasswordButton.setTitleColor(.white, for: .normal)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0 ,animations: {
                feedbackView.alpha = 0.0
                self.resetPasswordButton.setTitleColor(.lightGray, for: .normal)
            }) { (_) in
                feedbackView.removeFromSuperview()
                
            }
            
        }
    }
    private func highlightMissingField(view: UIView) {
        
        let originColor = view.backgroundColor
        
        UIView.animate(withDuration: 0.2, animations: {
            view.backgroundColor = .systemRed
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                view.backgroundColor = originColor
            }, completion: nil)
        }
        
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
        
        logInAccount()
        
    }
    private func logInAccount() {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            let logInManager = LogInManager(email: email, password: password)
            logInManager.logInAccount()
            logInManager.delegate = self
        }

        
    }
    
}
extension SignInVC: LogInManagerDelegate {
    func didLogIn() {
        let destinationVC = BaseNavigatorVC()
        self.navigationController?.pushViewController(destinationVC, animated: true)
    }
    func didSendPasswordResetEmail() {
        resetPasswordButton.setTitleColor(.systemGreen, for: .normal)
        resetPasswordButton.setTitle("e-mail envoyé", for: .normal)
    }

}
extension SignInVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        logInAccount()
        
        return true
    }
}

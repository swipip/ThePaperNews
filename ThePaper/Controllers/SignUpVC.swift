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
    private var confirmationImage:  UIImageView!
    private var errorLiterallabel:  UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationItem.title = "The Paper"
        
        self.view.backgroundColor = K.shared.mainColorBackground

        setUpUI()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        let _ = setBackgroundView(for: emailTextField)
        let _ = setBackgroundView(for: passwordTextField)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setUpUI() {
        
        addEmailTextField()
        
        addPasswordTextField()
        
        addButton()
        
        addConfirmationImage()
        
        addErrorLiterallabel()
        
    }
    private func addErrorLiterallabel() {
        
        errorLiterallabel = UILabel()
        errorLiterallabel.textColor = .lightGray
        errorLiterallabel.numberOfLines = 0
        errorLiterallabel.textAlignment = .center
        
        self.view.addSubview(errorLiterallabel)
        
        //view
        let fromView = errorLiterallabel!
        //relative to
        let toView = self.passwordTextField!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 10)])
        
    }
    private func addConfirmationImage() {
        confirmationImage = UIImageView()
        confirmationImage.image = UIImage(systemName: "clock.fill")
        confirmationImage.tintColor = .systemOrange
        confirmationImage.contentMode = .scaleAspectFit
        confirmationImage.alpha = 0.0
        
        self.view.addSubview(confirmationImage)
        
        //view
        let fromView = confirmationImage!
        //relative to
        let toView = self.passwordTextField!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.widthAnchor.constraint(equalToConstant: 70),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 70),
                                     fromView.heightAnchor.constraint(equalToConstant: 70)])
    }
    private func highlightMissingField(view: UIView) {
        
        let originColor = view.backgroundColor
        
        let view = setBackgroundView(for: view)!
        
        UIView.animate(withDuration: 0.2, animations: {
            view.backgroundColor = .systemRed
        }) { (_) in
            UIView.animate(withDuration: 0.2, delay: 1 ,animations: {
                view.backgroundColor = originColor
            }, completion: {(ended) in
                view.removeFromSuperview()
            })
        }
        
    }
    private func addButton() {
        
        signInButton = UIButton()
        signInButton.setUpButton()
        signInButton.setTitle("Créer un compte", for: .normal)
        
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
    private func setBackgroundView(for textField: UIView) -> UIView?{
        
        let view = UIView()
        view.frame = textField.frame
        view.backgroundColor = K.shared.grayTextFieldBackground
        view.layer.cornerRadius = 6
        
        self.view.insertSubview(view, at: 0)
        
        return view
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
    private func animateConfirmationImageOnWrongPassword() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.confirmationImage.image = UIImage(systemName: "xmark.circle.fill")
            self.confirmationImage.alpha = 1.0
            self.confirmationImage.tintColor = .systemRed
        }, completion: nil)
        UIView.animate(withDuration: 0.5, delay: 2 ,animations: {
            self.confirmationImage.alpha = 0.0
        }) { (_) in
            self.confirmationImage.image = UIImage(systemName: "clock.fill")
            self.confirmationImage.tintColor = .systemOrange
        }
        
    }
    
    func didGetAnError(error: Error) {
        
        if let errCode = AuthErrorCode(rawValue: error._code) {
            
            switch errCode {
            case .emailAlreadyInUse:
                highlightMissingField(view: emailTextField)
                animateConfirmationImageOnWrongPassword()
                emailTextField.text = ""
                emailTextField.becomeFirstResponder()
                errorLiterallabel.animateAlpha(on: true)
                errorLiterallabel.text = "Cet email est déjà associé à un compte"
                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
                    self.errorLiterallabel.animateAlpha(on: false)
                    timer.invalidate()
                }
                
            default:
                print("Create User Error: \(error)")
            }
        }
    }
    
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
        
        DataBaseManager.shared.savePreferences(preferences)
        
    }

}

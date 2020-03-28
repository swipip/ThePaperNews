//
//  SignInAppleVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 28/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import AuthenticationServices

class SignInAppleVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpView()
        
    }
    private func setUpView() {
        
        let appleIdButton = ASAuthorizationAppleIDButton()
        appleIdButton.addTarget(self, action: #selector(appleIdButtonPressed), for: .touchUpInside)
        
        self.view.addSubview(appleIdButton)
        
        //view
        let fromView = appleIdButton
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
    }
    
    @objc
    private func appleIdButtonPressed() {
        
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        
        controller.delegate = self
        controller.presentationContextProvider = self
        
        controller.performRequests()
        
    }

}
extension SignInAppleVC: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credentials as ASAuthorizationAppleIDCredential:
            
            let user = User(credentials: credentials)
            print(user)
            
        default:
            break
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("error with apple sign in\(error)")
    }
    
}

//
//  ViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 16/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON
import AuthenticationServices

class WelcomeVC: UIViewController {
    
//    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
//    @IBOutlet weak var imageView: UIImageView!
    
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    
    fileprivate func setUpButton(for button: UIButton) {
        button.layer.cornerRadius = button.frame.size.height / 2
        button.layer.shadowRadius = 8
        button.layer.shadowOpacity = 0.8
        button.layer.shadowColor = UIColor.lightGray.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = ""
        
        self.navigationController?.navigationBar.isHidden = true
        
        
        
        self.view.backgroundColor = .white
        
        signInButton = addButtons(yConstraint: 160, title: "Sing In")
        signUpButton = addButtons(yConstraint: 220, title: "Sing Up")

        addLogo()
        
        addAppleIDController() 
        
    }
    func addAppleIDController() {
        
        let appleVC = SignInAppleVC()
        addChild(appleVC)
        appleVC.didMove(toParent: self)
        self.view.addSubview(appleVC.view)
        
        //view
        let fromView = appleVC.view!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -100),
                                     fromView.heightAnchor.constraint(equalToConstant: 50)])
        
    }
    override func viewDidAppear(_ animated: Bool) {
        signInButton.setUpButton()
        signUpButton.setUpButton()
        
//        UIView.animate(withDuration: 80, delay: 0, options: .curveLinear, animations: {
//            self.leadingConstraint.constant = -400
//            self.view.layoutIfNeeded()
//        }) { (_) in
//
//        }
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    private func addLogo() {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ThePaperLogo")
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
        
        //view
        let fromView = imageView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20),
                                     fromView.heightAnchor.constraint(equalToConstant: 200),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor,constant: 250)])
        
    }
    private func addButtons(yConstraint: CGFloat, title: String) -> UIButton {

        let newButton = UIButton()
        newButton.backgroundColor = UIColor(named: "mainColorTheme")
        newButton.setTitle(title, for: .normal)
        self.view.addSubview(newButton)
        
        
        //view
        let fromView = newButton
        //relative to
        let toView = self.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.heightAnchor.constraint(equalToConstant: 50),
                                     fromView.bottomAnchor.constraint(equalTo:  toView.bottomAnchor, constant: -yConstraint),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: -20)])
        
        newButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        return newButton

    }
    fileprivate func animateButtonsOnDismiss(button: UIButton,segueID: String) {
        
        let feedBackButton = button == signUpButton ? signInButton : signUpButton
        
        let feedbackView = UIView()
        feedbackView.frame = feedBackButton!.frame
        feedbackView.backgroundColor = UIColor(named: "mainColorTheme")
        feedbackView.layer.cornerRadius = 25
        feedbackView.alpha = 0.8
        
        self.view.insertSubview(feedbackView, at: 1)
        
        UIView.animate(withDuration: 0.3, animations: {
            button.backgroundColor = .lightGray
            feedbackView.transform = CGAffineTransform(scaleX: 3, y: 3)
            feedbackView.alpha = 0.0
            feedbackView.layer.cornerRadius = 75
        }) { (_) in
            feedbackView.removeFromSuperview()
            if button == self.signInButton {
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "SignUpVC") as! SignUpVC
                self.navigationController?.pushViewController(resultViewController, animated: true)
            }else{
                
                let vc = SignInVC()
                vc.view.backgroundColor = .white
                self.navigationController?.pushViewController(vc, animated: true)
                
//                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//                let resultViewController = storyBoard.instantiateViewController(withIdentifier: "SignInVC") as! SignInVC
//                self.navigationController?.pushViewController(resultViewController, animated: true)
            }

        }
    }
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        
        if sender == signInButton {
            animateButtonsOnDismiss(button: signUpButton,segueID: "toSignIn")
        }else if sender == signUpButton {
            animateButtonsOnDismiss(button: signInButton,segueID: "toSignUp")
        }

//        #warning("Replace with original code on homescreen VC")
//        self.performSegue(withIdentifier: "homeToBaseVC", sender: self)
        
    }
}

extension UIButton {
    func setUpButton() {
        self.layer.cornerRadius = 6
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}


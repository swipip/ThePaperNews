//
//  ViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 16/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageView: UIImageView!
    
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
        
        self.navigationController?.navigationBar.isHidden = true
        
        signInButton = addButtons(yConstraint: 100, title: "Sing In")
        signUpButton = addButtons(yConstraint: 160, title: "Sing Up")

        addLogo()
        

        
    }
    override func viewDidLayoutSubviews() {

    }
    override func viewDidAppear(_ animated: Bool) {
        signInButton.setUpButton()
        signUpButton.setUpButton()
        
        UIView.animate(withDuration: 100) {
            self.leadingConstraint.constant = -400
            self.view.layoutIfNeeded()
        }
        
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
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width * 0.8),
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
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 50),
                                     fromView.bottomAnchor.constraint(equalTo:  toView.bottomAnchor, constant: -yConstraint),
                                     fromView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width * 0.8)])
        
        newButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
        
        return newButton

    }
    @IBAction private func buttonPressed(_ sender: UIButton) {
        
        if sender == signInButton {
            performSegue(withIdentifier: "toSignIn", sender: self)
        }else if sender == signUpButton {
            performSegue(withIdentifier: "toSignUp", sender: self)
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSignIn" {
            if let newVC = segue.destination as? SignUpVC {
                newVC.registration = .signIn
            }
        }else if segue.identifier == "toSignUp"{
            if let newVC = segue.destination as? SignUpVC {
                newVC.registration = .signUp
            }
        }
    }
    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {

    }
}

extension UIButton {
    func setUpButton() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

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
    
    private var trailingContraint: NSLayoutConstraint!
    private var imageView: UIImageView!
    private var launchVC: LaunchVC!
    private var signInButton: UIButton!
    private var signUpButton: UIButton!
    private var buttonBackGround: UIView!
    private var buttonBackGroundBottomConstraint: NSLayoutConstraint!
    private var appleButton: UIViewController!
    private var OtherSignInMethodsButton: UIButton!
    private var handle: UIView!
    private var animators = [UIViewPropertyAnimator]()
    private var buttonsConstraints = [NSLayoutConstraint]()
    
    var animationProgressWhenInterrupted:CGFloat = 0
    var cardVisible = false
    var nextState: buttonBackgroundState {
        return cardVisible ? .collapsed : .expanded
    }
    
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

        self.view.backgroundColor = UIColor(named: "mainColorBackground")
        
        addBackground()
        addButtonBackground()
        addHandle()
        addAppleIDController()
        addShowOtherSignInMethodsButton()
        signInButton = addButtons(yConstraint: 95, title: "Connexion")
        signUpButton = addButtons(yConstraint: 155, title: "Créer un Compte")

        addLogo()

        addLaunchAnimation()
        
    }
    private func addHandle() {
        
        let visibleHandle = UIView()
        visibleHandle.backgroundColor = .white
        visibleHandle.layer.cornerRadius = 3
        
        self.view.addSubview(visibleHandle)
            
        visibleHandle.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([visibleHandle.topAnchor.constraint(equalTo: self.buttonBackGround.topAnchor, constant: 12),
                                     visibleHandle.widthAnchor.constraint(equalToConstant: 80),
                                     visibleHandle.centerXAnchor.constraint(equalTo: self.buttonBackGround.centerXAnchor, constant: 0),
                                     visibleHandle.heightAnchor.constraint(equalToConstant: 6)])
        
        handle = UIView()
        handle.backgroundColor = .clear
        
        self.view.addSubview(handle)
        
        //view
        let fromView = handle!
        //relative to
        let toView = buttonBackGround!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.widthAnchor.constraint(equalToConstant: 300),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 30)])
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        handle.addGestureRecognizer(panGesture)

    }
    @objc private func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        switch recognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: 0.9)
            
        case .changed:
            let translation = recognizer.translation(in: self.view)
            
            var fractionComplete = translation.y / 340
            
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
        
    }
    func startInteractiveTransition(state:buttonBackgroundState, duration:TimeInterval) {
        
        if animators.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in animators {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }


    }
    func updateInteractiveTransition(fractionCompleted:CGFloat) {
        
        for animator in animators {
            animator.fractionComplete = fractionCompleted + animationProgressWhenInterrupted
        }
        
    }
    
    func continueInteractiveTransition (){
        
        for animator in animators {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
        
    }
    enum buttonBackgroundState {
        case expanded, collapsed
    }
    func animateTransitionIfNeeded (state:buttonBackgroundState, duration:TimeInterval) {
        if animators.isEmpty {
            let animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .expanded:
                    self.buttonBackGroundBottomConstraint.constant = 10
                    
                    let position:[CGFloat] = [10,70]
                    
                    for (i,constraint) in self.buttonsConstraints.enumerated() {
                        constraint.constant = position[i]
                    }
                    
                    self.view.layoutIfNeeded()
                case .collapsed:
                    self.buttonBackGroundBottomConstraint.constant = 180
                    
                    let position:[CGFloat] = [95,155]
                    
                    for (i,constraint) in self.buttonsConstraints.enumerated() {
                        constraint.constant = position[i]
                        
                    }
                    
                    self.view.layoutIfNeeded()
                }
            }
            animator.addCompletion { (_) in
                self.cardVisible.toggle()
                self.animators.removeAll()
                if state == .expanded {
                    self.OtherSignInMethodsButton.animateAlpha(on: false)
                }else{
                    self.OtherSignInMethodsButton.animateAlpha(on: true)
                }

            }
            
            animator.startAnimation()
            animators.append(animator)
            
        }
        
    }
    private func addShowOtherSignInMethodsButton() {
        
        OtherSignInMethodsButton = UIButton()
        OtherSignInMethodsButton.setTitle("Voir d'autres methodes d'inscription", for: .normal)
        OtherSignInMethodsButton.setTitleColor(.white, for: .normal)
        
        self.view.addSubview(OtherSignInMethodsButton)
        
        //view
        let fromView = OtherSignInMethodsButton!
        //relative to
        let toView = self.appleButton.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 5),
                                     fromView.heightAnchor.constraint(equalToConstant: 40)])
        
        OtherSignInMethodsButton.addTarget(self, action: #selector(showOtherSignMethods(_:)), for: .touchUpInside)
        
    }
    @IBAction private func showOtherSignMethods(_ sender: UIButton!) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.OtherSignInMethodsButton.alpha = 0.0
            self.buttonBackGroundBottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }) { (_) in
            self.OtherSignInMethodsButton.isEnabled = false
        }
        
    }
    private func addLaunchAnimation() {
        launchVC = LaunchVC()
        launchVC.delegate = self
        self.addChild(launchVC)
        self.willMove(toParent: launchVC)
        launchVC.view.frame = self.view.frame
        self.view.addSubview(launchVC.view)
    }
    private func checkLogIn() -> Bool{
        
        if defaults.bool(forKey: K.shared.loggedIn) {
            return true
        }else{
            return false
        }
        
    }
    private func addWelcomeLabel() {
        
        let label = UILabel()
        label.text = "Welcome Back!"
        label.font = UIFont.systemFont(ofSize: 20)
        label.contentMode = .center
        
        self.view.addSubview(label)
        
        //view
        let fromView = label
        //relative to
        let toView = self.signUpButton!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.topAnchor, constant: -20)])
        
    }
    private func addBackground() {
        
        let width = self.view.frame.width
        
        imageView = UIImageView()
        imageView.image = K.shared.backgroundImage
        imageView.contentMode = .scaleAspectFit
        imageView.frame.origin.x = 0//-width * 2
        imageView.frame.origin.y = 0
        imageView.frame.size = CGSize(width: width * 2, height: self.view.frame.size.height)
        
        self.view.addSubview(imageView)
        
        
    }
    private func addAppleIDController() {
        
        appleButton = SignInAppleVC()
        addChild(appleButton)
        appleButton.didMove(toParent: self)
        self.view.addSubview(appleButton.view)
        
        //view
        let fromView = appleButton.view!
        //relative to
        let toView = self.buttonBackGround!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 30),
                                     fromView.heightAnchor.constraint(equalToConstant: 50)])
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
        signInButton.setUpButton(color: .white)
        signInButton.setTitleColor(.black, for: .normal)
        signUpButton.setUpButton(color: .white)
        signUpButton.setTitleColor(.black, for: .normal)
        
        UIView.animate(withDuration: 80, delay: 0, options: .curveLinear, animations: {
            self.imageView.frame.origin.x = -self.view.frame.width
            self.view.layoutIfNeeded()
        }) { (_) in

        }
        
    }
    deinit {
        print("deninit")
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    private func addButtonBackground() {
        buttonBackGround = UIView()
        buttonBackGround.backgroundColor = K.shared.mainColorTheme
        buttonBackGround.roundCorners([.topLeft,.topRight], radius: 12)
        
        self.view.insertSubview(buttonBackGround, at: 1)
        //view
        let fromView = buttonBackGround!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 350)])
        
        buttonBackGroundBottomConstraint = NSLayoutConstraint(item: buttonBackGround!,
                                                              attribute: .bottom,
                                                              relatedBy: .equal,
                                                              toItem: self.view,
                                                              attribute: .bottom,
                                                              multiplier: 1,
                                                              constant: 180)
        
        self.view.addConstraint(buttonBackGroundBottomConstraint)
        
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
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor,constant: 150)])
        
    }
    private func addButtons(yConstraint: CGFloat, title: String) -> UIButton {

        let newButton = UIButton()
        newButton.backgroundColor = UIColor(named: "mainColorTheme")
        newButton.setTitle(title, for: .normal)
        self.view.addSubview(newButton)
        
        
        //view
        let fromView = newButton
        //relative to
        let toView = self.appleButton.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 50),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor ,constant: 0)])
        
        let constraint = NSLayoutConstraint(item: newButton, attribute: .top, relatedBy: .equal, toItem: self.appleButton.view!, attribute: .bottom, multiplier: 1, constant: yConstraint)
        
        buttonsConstraints.append(constraint)
        
        self.view.addConstraint(constraint)
        
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
            
                feedBackButton?.backgroundColor = .lightGray
             
            feedbackView.transform = CGAffineTransform(scaleX: 3, y: 3)
            feedbackView.alpha = 0.0
            feedbackView.layer.cornerRadius = 75
        }) { (_) in
            feedbackView.removeFromSuperview()
            if button == self.signInButton {
                let vc = SignUpVC()
                vc.view.backgroundColor = K.shared.mainColorBackground
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = SignInVC()
                vc.view.backgroundColor = K.shared.mainColorBackground
                self.navigationController?.pushViewController(vc, animated: true)
            }

        }
    }
    
    @IBAction private func buttonPressed(_ sender: UIButton) {
        
        if sender == signInButton {
            animateButtonsOnDismiss(button: signUpButton,segueID: "toSignIn")
        }else if sender == signUpButton {
            animateButtonsOnDismiss(button: signInButton,segueID: "toSignUp")
        }
    }
}

extension UIButton {
    func setUpButton(color: UIColor? = nil) {
        self.backgroundColor = color ?? K.shared.mainColorTheme
        self.layer.cornerRadius = 6
        self.layer.shadowRadius = 8
        self.layer.shadowOpacity = 0.6
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}
extension WelcomeVC: LaunchVCDelegate {
    func LaunchScreenDidAnimate() {
        
        launchVC.view.removeFromSuperview()
        self.willMove(toParent: self)
        launchVC.removeFromParent()
        
        let loggedIn = checkLogIn()
        
        if loggedIn {
            
            let vc = BaseNavigatorVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
}

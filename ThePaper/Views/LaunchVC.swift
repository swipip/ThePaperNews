//
//  LaunchVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 01/04/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

protocol LaunchVCDelegate {
    func LaunchScreenDidAnimate()
}

class LaunchVC: UIViewController {

    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = K.shared.backgroundLaunch
        imageView.frame = self.view.frame
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    lazy var logoLabel: UILabel = {
       let label = UILabel()
        label.text = "P"
        label.textAlignment = .center
        label.frame.size = CGSize(width: 250, height: 250)
        label.font = UIFont(name: "Old London", size: 200)
        label.textColor = .white
        label.alpha = 0.0
        label.center = self.view.center
        return label
    }()
    
    var delegate: LaunchVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(imageView)
        
        self.view.addSubview(logoLabel)
        
        animate()
        
    }
    func animate() {
        
        UIView.animate(withDuration: 0.2, animations: {
            self.logoLabel.alpha = 1.0
        }, completion: nil)
        
        UIView.animate(withDuration: 0.2, delay: 1 ,animations: {
            self.logoLabel.transform = CGAffineTransform(scaleX: 10, y: 10)
            self.logoLabel.alpha = 0.0
            self.imageView.alpha = 0.0
        }) { (_) in
            self.delegate?.LaunchScreenDidAnimate()
        }
        
    }

}

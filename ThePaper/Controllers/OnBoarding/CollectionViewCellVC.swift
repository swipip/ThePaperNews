//
//  CollectionViewCellVC.swift
//  OnBoardingThePaper
//
//  Created by Gautier Billard on 29/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class CollectionViewCellVC: UIViewController {

    var category: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .clear
        
        addShadowView()
        addLabel()
        addImage()
        
    }
    private func addShadowView() {
        
        let shadowView = UIView()
        shadowView.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        shadowView.clipsToBounds = false
        shadowView.layer.cornerRadius = 8
        shadowView.addShadow(radius: 8, color: .gray, opacity: 0.5)
        
        self.view.addSubview(shadowView)
        
        //view
        let fromView = shadowView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 20),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -20)])
        
    }
    private func addImage() {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: category ?? "Politique")
        imageView.contentMode = .scaleAspectFit
        
        self.view.addSubview(imageView)
        
        //view
        let fromView = imageView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 50),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -50),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 50),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -100)])
        
    }
    private func addLabel() {
        
        let label = UILabel()
        label.text = category ?? "no category"
        label.font = UIFont.systemFont(ofSize: 25)
        label.textAlignment = .center
        
        self.view.addSubview(label)
        
        
        //view
        let fromView = label
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 0),
                                     fromView.widthAnchor.constraint(equalToConstant: 200),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -50)])
        
    }



}

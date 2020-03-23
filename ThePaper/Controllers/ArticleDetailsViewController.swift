//
//  ArticleDetailsViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 18/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class ArticleDetailsViewController: UIViewController {

    var content: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addLabel()
        
    }
    func addLabel() {
        
        let label = UILabel()
        label.text = content ?? "no text"
        label.numberOfLines = 0
        self.view.addSubview(label)
        
        //view
        let fromView = label
        //relative to
        let toView = self.view
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView!.centerXAnchor, constant: 20),
                                     fromView.centerYAnchor.constraint(equalTo: toView!.centerYAnchor, constant: 20)])
        
    }

}

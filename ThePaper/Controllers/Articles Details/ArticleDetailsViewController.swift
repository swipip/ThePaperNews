//
//  ArticleDetailsViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 18/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import WebKit

class ArticleDetailsViewController: UIViewController {

    private var webView = WKWebView()
    private let k = K()
    var articleURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addWebView()
        addDismissButton()
        
        let url = URL(string: articleURL)
        let urlRequest = URLRequest(url: url!)
        webView.load(urlRequest)
        
    }
    private func addDismissButton() {
        
        let dismissButton = UIButton()
        dismissButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        dismissButton.backgroundColor = k.mainColorTheme
        dismissButton.tintColor = .white
        dismissButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        dismissButton.layer.shadowRadius = 4
        dismissButton.layer.shadowOpacity = 0.2
        dismissButton.layer.shadowColor = UIColor.gray.cgColor
        dismissButton.layer.cornerRadius = 20
        
        self.view.addSubview(dismissButton)
        
        //view
        let fromView = dismissButton
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.widthAnchor.constraint(equalToConstant: 40),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10),
                                     fromView.heightAnchor.constraint(equalToConstant: 40)])
        
        dismissButton.addTarget(self, action: #selector(dismissPressed(_:)), for: .touchUpInside)
        
        
    }
    @IBAction private func dismissPressed(_ sender: UIButton!) {
        
        self.willMove(toParent: nil)
        self.view.removeFromSuperview()
        self.removeFromParent()
        
    }
    fileprivate func addWebView() {
        self.view.addSubview(webView)
        
        //view
        let fromView = webView
        //relative to
        let toView = self.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0)])
    }
}

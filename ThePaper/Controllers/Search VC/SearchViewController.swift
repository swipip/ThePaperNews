//
//  ViewController.swift
//  NewsCard
//
//  Created by Gautier Billard on 06/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON

class SearchViewController: UIViewController {
    
    private var textField: UITextField!
    private var tableView: UITableView!
    private var barConstraints = [NSLayoutConstraint]()
    private var childTableVC: TableVC?
    //Data
    private var newsModel = NewsModel()
    private var titles = [String]()
    private var imagesUrls = [String]()
    private var contents = [String]()
    private let language = ["au":"en","gb":"en","us":"en"]
    struct Cells {
        static let NewsCell = "NewsCell"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSearchBar()
        
        animateSearchBar()
        
        addObservers()
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    fileprivate func addObservers() {
        
        let mapDismissNotifName = Notification.Name(rawValue: K.shared.locationChangeNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeCountry), name: mapDismissNotifName, object: nil)
        
        let cvcSelectionNotifName = Notification.Name(rawValue: K.shared.cvcSelectionNotifName)
        NotificationCenter.default.addObserver(self, selector: #selector(navDidSelectSearch), name: cvcSelectionNotifName, object: nil)
        
    }
    @objc private func navDidSelectSearch() {
        childTableVC?.tableViewReloadData()
    }
    @objc private func didChangeCountry() {
        fetchData()
    }
    fileprivate func addTableVC() {
        childTableVC = TableVC()
        childTableVC!.hasATitleBar = false
        addChild(childTableVC!)
        self.view.addSubview(childTableVC!.view)
        
        //view
        let fromView = childTableVC!.view!
        //relative to
        let toView = self.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 60),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
    }
    fileprivate func animateSearchBar() {
        //        addTableView()
        
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            
            let value:[CGFloat] = [-10.0,10.0]
            
            for (i,constraint) in self.barConstraints.enumerated() {
                constraint.constant = value[i]
                self.view.layoutIfNeeded()
            }
            
        }) { (_) in
//            self.textField.becomeFirstResponder()
        }
    }
    func addSearchBar() {
        
        let searchBarBack = UIView()
        searchBarBack.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
        
        searchBarBack.layer.cornerRadius = 20
        
        self.view.addSubview(searchBarBack)
        
        
        //view
        var fromView = searchBarBack
        //relative to
        var toView = self.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10),
                                     fromView.heightAnchor.constraint(equalToConstant: 40)])
        
        let trailingConstraint = NSLayoutConstraint(item: fromView, attribute: .trailing, relatedBy: .equal, toItem: toView, attribute: .trailing, multiplier: 1, constant: -150)
        
        barConstraints.append(trailingConstraint)
        
        let leadingConstraint = NSLayoutConstraint(item: fromView, attribute: .leading, relatedBy: .equal, toItem: toView, attribute: .leading, multiplier: 1, constant: 150)
        
        barConstraints.append(leadingConstraint)
        
        self.view.addConstraints(barConstraints)
        self.view.layoutIfNeeded()
        
        let image = UIImageView()
        image.image = UIImage(systemName: "magnifyingglass.circle")
        image.tintColor = .white
        searchBarBack.addSubview(image)
        
        //view
        fromView = image
        //relative to
        toView = searchBarBack
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.widthAnchor.constraint(equalToConstant: 30),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -5),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 5),
                                     fromView.heightAnchor.constraint(equalToConstant: 30)])
        
        textField = UITextField()
        textField.backgroundColor = .clear
        textField.tintColor = .white
        textField.textColor = .white
        textField.delegate = self
        searchBarBack.addSubview(textField)
        
        //view
        fromView = textField
        //relative to
        toView = searchBarBack
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 15),
                                     fromView.trailingAnchor.constraint(equalTo: image.leadingAnchor, constant: -5),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 2),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -2)])
        
    }
}

extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        self.childTableVC?.view.removeFromSuperview()
        
        addTableVC()
        
        fetchData()
        
        return true
    }
    func fetchData() {
        
        let language = self.language[localISOCode] == nil ? localISOCode : self.language[localISOCode]
        
        let urlString = "https://newsapi.org/v2/everything?qInTitle=\(String(describing: textField.text!))&pageSize=100&sortBy=publishedAt&from=2020-03-17&to=2020-03-17&sortBy=popularity&language=\(language!)"
        
        childTableVC?.urlString = urlString
    }
}


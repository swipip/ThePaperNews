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
    //Data
    private var newsModel = NewsModel()
    private var titles = [String]()
    private var imagesUrls = [String]()
    private var contents = [String]()
    
    struct Cells {
        static let NewsCell = "NewsCell"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsModel.jsonDelegate = self
        
        addSearchBar()
        
        animateSearchBar()
    }
    fileprivate func animateSearchBar() {
        //        addTableView()
        
        UIView.animate(withDuration: 0.2, delay: 0.2, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
            
            let value:[CGFloat] = [-20.0,20.0]
            
            for (i,constraint) in self.barConstraints.enumerated() {
                constraint.constant = value[i]
                self.view.layoutIfNeeded()
            }
            
        }) { (_) in
            self.textField.becomeFirstResponder()
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
    func addTableView(){
        
        tableView = UITableView()
        tableView.register(NewsCell.self, forCellReuseIdentifier: Cells.NewsCell)
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        
        //view
        let fromView = tableView!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 15),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor ,constant: 0)])
        
    }
    
}
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.NewsCell, for: indexPath) as! NewsCell
        
        if titles.count != 0 {
            cell.passDataToNewsCell(title: titles[indexPath.row], imageUrl: imagesUrls[indexPath.row],articleURL: contents[indexPath.row])
        }
        
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
extension SearchViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        
        addTableView()
        
        let urlString = "https://newsapi.org/v2/everything?q=\(String(describing: textField.text!))&from=2020-03-17&to=2020-03-17&sortBy=popularity&language=fr&apiKey="
        
        newsModel.fetchData(urlString: urlString)
        
        return true
    }
    
}
extension SearchViewController: NewsModelDelegate {
    func didFetchData(json: JSON) {
        
        titles = json["articles"].arrayValue.map {$0["title"].stringValue}
        contents = json["articles"].arrayValue.map {$0["content"].stringValue}
        imagesUrls = json["articles"].arrayValue.map {$0["urlToImage"].stringValue}
        
        tableView.reloadData()
    }
    
    
}

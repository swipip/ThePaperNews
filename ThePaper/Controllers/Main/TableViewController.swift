//
//  tableViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 23/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON

class tableViewController: UIViewController {

    private var tableView: UITableView!
    //data
    private var newsModel = NewsModel()
    private var titles = [String]()
    private var imagesUrls = [String]()
    private var articleURL = [String]()
    struct Cells {
        static let NewsCell = "NewsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        newsModel.jsonDelegate = self
        newsModel.fetchData()
        
        addTableView()
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: Cells.NewsCell)
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func createObservers() {
        
        let name = Notification.Name(countryObserverKey)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewsWithCountry(_:)), name: name, object: nil)
        
    }
    @objc private func updateNewsWithCountry(_ notification: NSNotification) {
        newsModel.fetchData(urlString: "", country: notification.userInfo?["country"] as? String)
    }
    func addTableView() {
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: 0),
                                     tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0)])
    }
}
extension tableViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.NewsCell, for: indexPath) as! NewsCell
        
        if titles.count != 0 {
            cell.passDataToNewsCell(title: titles[indexPath.row], imageUrl: imagesUrls[indexPath.row],articleURL: articleURL[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let childVC = ArticleDetailsViewController()

        childVC.articleURL = self.articleURL[indexPath.row]
        
        addChild(childVC)
        self.view.addSubview(childVC.view)
        childVC.didMove(toParent: self)

        let childView = childVC.view
        childView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([childView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     childView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                                     childView!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
                                     childView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
extension tableViewController: NewsModelDelegate {
    func didFetchData(json: JSON) {
        
        titles = json["articles"].arrayValue.map {$0["title"].stringValue}
        articleURL = json["articles"].arrayValue.map {$0["url"].stringValue}
        imagesUrls = json["articles"].arrayValue.map {$0["urlToImage"].stringValue}
        
        tableView.reloadData()
    }
    
    
}

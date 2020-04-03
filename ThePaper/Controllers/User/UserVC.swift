//
//  UserVC.swift
//  UserVC
//
//  Created by Gautier Billard on 31/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON
import NaturalLanguage

class UserVC: UIViewController {

    //Data
    private var sectionHeaders: [String]?
    private var newsModel = NewsModel()
    private var articlePerCategory = [String:Int]()
    private var articles: [Article]?
    
    private var cellStateForRow = [cellState]()
    
    private lazy var tableView: UITableView =  {
       let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsCell.self, forCellReuseIdentifier: CellID.id)
        return tableView
    }()
    enum cellState {
        case display, noDisplay
    }
    struct CellID {
        static let id = "CellID"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTableView()
        loadData()
        addObservers()
        
    }
    private func addObservers() {
        
        let name = Notification.Name(K.shared.userSettingDidChangeNotificationName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didChangeUserSettings), name: name, object: nil)
        
    }
    @objc private func didChangeUserSettings() {
        
        self.loadData()
        
    }
    private func loadData() {
        
        cellStateForRow.removeAll()
        articlePerCategory.removeAll()
        sectionHeaders?.removeAll()
        sectionHeaders = [String]()
        
        if let user = Auth.auth().currentUser {
            db.collection("usersPreferences").whereField("user", isEqualTo: user.email!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if let property = data["preference"] as? String {
                                self.sectionHeaders?.append(property)
                            }
                        }
                        self.newsModel.fetchData()
                        self.newsModel.jsonDelegate = self
                        
                    }
            }
        }
    }
    private func addTableView() {
        
        self.view.addSubview(tableView)
        
        //view
        let fromView = tableView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
    }

}
extension UserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows = 0
        for (key,qty) in articlePerCategory {
            if key == sectionHeaders![section]{
                    numberOfRows += qty
            }
        }
        
        return max(1,numberOfRows)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionHeaders?.count ?? 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var currentSectionArticles = [Article]()
        
        if let sectionHeader = sectionHeaders?[indexPath.section] {
            if let articles = self.articles {
                for(_,article) in articles.enumerated(){
                    if article.category == sectionHeader {
                        currentSectionArticles.append(article)
                    }
                }
            }
            
            if currentSectionArticles.count == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: CellID.id, for: indexPath) as! NewsCell
                
                 cell.setBlankCell()
                
                cellStateForRow.append(.noDisplay)
                
                return cell
            }else{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: CellID.id, for: indexPath) as! NewsCell
                
                cellStateForRow.append(.noDisplay)
                
                let article = currentSectionArticles[indexPath.row]
                cell.passDataToNewsCell(title: article.title, imageUrl: article.imageUrl, articleURL: article.url)
                
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: CellID.id, for: indexPath) as! NewsCell
            
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white

        let sectionLabel = UILabel()
        sectionLabel.font = UIFont.systemFont(ofSize: K.shared.fontSizeSubTitle)
        sectionLabel.textColor = UIColor.black
        sectionLabel.text = sectionHeaders?[section] ?? "section title"
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        //view
        let fromView = sectionLabel
        //relative to
        var toView = headerView
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0)])

        let underStroke = UIView()
        underStroke.backgroundColor = K.shared.mainColorTheme
        
        headerView.addSubview(underStroke)
        
        //view
        let fromViewTwo = underStroke
        //relative to
        toView = headerView
            
        fromViewTwo.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromViewTwo.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 8),
                                     fromViewTwo.widthAnchor.constraint(equalToConstant: 150),
                                     fromViewTwo.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -5),
                                     fromViewTwo.heightAnchor.constraint(equalToConstant: 3)])
        
        return headerView
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! NewsCell
        
        let childVC = ArticleDetailsViewController()
        childVC.articleURL = cell.articleURL

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
}
extension UserVC: NewsModelDelegate {
    
    func didFetchData(json: JSON) {

        articles?.removeAll()
        
        let titles = json["articles"].arrayValue.map {$0["title"].stringValue}
        let articleURL = json["articles"].arrayValue.map {$0["url"].stringValue}
        let imagesUrls = json["articles"].arrayValue.map {$0["urlToImage"].stringValue}
        
        articles = [Article]()
        
        for (i,title) in titles.enumerated() {
 
            let category = TitleIdentifierModel.shared.performIdentification(for: title)
            let article = Article(title: title,
                                  url: articleURL[i],
                                  imageUrl: imagesUrls[i] ,
                                  category: category)
            
            articles?.append(article)
            
            
            for section in sectionHeaders! {
                if section == article.category {
                    let count = (articlePerCategory[section] ?? 0) + 1
                    articlePerCategory[section] = count
                }
            }

        }
        
        self.tableView.reloadData()
        
    }
 
}

//
//  TableVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 25/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON

class TableVC: UIViewController {

    private var tableView: UITableView!
    private var mediaTitle: UILabel!
    private var topAnchor:CGFloat = 0.0
    //Data
    var urlString: String? {
        didSet{
            newsModel.fetchData(urlString: urlString)
        }
    }
    var mediaName: String?
    var hasATitleBar        = true
    
    private let k           = K()
    private let newsModel   = NewsModel()
    private var titles      = [String]()
    private var imagesUrls  = [String]()
    private var articleURL  = [String]()
    
    struct Cells {
        static let NewsCell = "NewsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        newsModel.jsonDelegate = self
//        newsModel.fetchData(urlString: urlString ?? "", country: "fr")
        
        if hasATitleBar {
            topAnchor = 50
            addTableView()
            addMediaTitle()
            mediaTitle.text = mediaName
            addDismissButton()
        }else{
            addTableView()
        }
        
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: Cells.NewsCell)
        
        
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.3) {
            self.view.alpha = 1.0
        }
    }
    func tableViewReloadData(){
        self.titles.removeAll()
        self.articleURL.removeAll()
        self.imagesUrls.removeAll()

        self.tableView.reloadData()
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
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 5),
                                     fromView.heightAnchor.constraint(equalToConstant: 40)])
        
        dismissButton.addTarget(self, action: #selector(dismissPressed(_:)), for: .touchUpInside)
        
        
    }
    @IBAction private func dismissPressed(_ sender: UIButton!) {
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0.0
        }) { (_) in
            self.willMove(toParent: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        }
 
    }
    private func addMediaTitle() {
        let backView = UIView()
        backView.backgroundColor = k.mainColorTheme
        self.view.addSubview(backView)
        
        //view
        var fromView = backView
        //relative to
        var toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 50)])
        
        mediaTitle = UILabel()
        mediaTitle.text = ""
        mediaTitle.textAlignment = .center
        mediaTitle.textColor = .white
        
        backView.addSubview(mediaTitle)
        
        //view
        fromView = mediaTitle
        //relative to
        toView = backView
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor ,constant: 0)])
        
    }
    private func addTableView() {

        tableView = UITableView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = true
        tableView.showsVerticalScrollIndicator = false
        
        self.view.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor ,constant: 0),
                                     tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: topAnchor),
                                     tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor,constant: 0)])
    }
}
extension TableVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if titles.count == 0 {
            return 10
        }else{
            print(titles)
            return titles.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.NewsCell, for: indexPath) as! NewsCell
        
        cell.passDataToNewsCell(title: "Fetching data...", imageUrl: "", articleURL: "")
        
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
extension TableVC: NewsModelDelegate {
    func didFetchData(json: JSON) {
        
        titles = json["articles"].arrayValue.map {$0["title"].stringValue}
        articleURL = json["articles"].arrayValue.map {$0["url"].stringValue}
        imagesUrls = json["articles"].arrayValue.map {$0["urlToImage"].stringValue}
        
        tableView.reloadData()
    }
    
    
}

//
//  TableViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 17/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON

class MainViewController: UIViewController {

    let cellID = "cellID"
    //UI
    private var tableView: UITableView!
    private var cardTitleView: UIView!
    private var tableTitleView: UIView!
    private var cardView: CardView!
    private var scrollVelocity = 1.0
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 636 + 260
        view.backgroundColor = .clear
        return view
    }()
    
    //Data
    private let newsModel = NewsModel()
    private var titles = [String]()
    private var imagesUrls = [String]()
    private var contents = [String]()
    
    struct Cells {
        static let NewsCell = "NewsCell"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(scrollView)
        
        scrollView.delegate = self
        
        addScrollViewConstraints()
        
        newsModel.jsonDelegate = self
        newsModel.fetchData()
        
        addCardTitle()
        addCardView()
        
        addTableTitle()
        addTableView()
        self.tableView.register(NewsCell.self, forCellReuseIdentifier: Cells.NewsCell)
        
        createObservers()
        
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
    func addScrollViewConstraints() {
        
        //view
        let fromView = scrollView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0)])
        
    }
    fileprivate func addCardTitle() {
        //Breaking news
        cardTitleView = UIView()
        cardTitleView.backgroundColor = .clear
        
        self.scrollView.addSubview(cardTitleView)
        
        cardTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cardTitleView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
                                     cardTitleView.widthAnchor.constraint(equalToConstant: 200),
                                     cardTitleView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10),
                                     cardTitleView.heightAnchor.constraint(equalToConstant: 30)])
        
        let cardTitle = UILabel()
        cardTitle.text = "Breaking"
        cardTitle.font = UIFont.systemFont(ofSize: 20)
//        cardTitle.font = UIFont(name: "Old London", size: 20)
        
        cardTitleView.addSubview(cardTitle)
        cardTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cardTitle.leadingAnchor.constraint(equalTo: self.cardTitleView.leadingAnchor, constant: 5),
                                     cardTitle.centerYAnchor.constraint(equalTo: self.cardTitleView.centerYAnchor, constant: 0)])
    }
    fileprivate func addTableTitle() {
        //Trending Now
        tableTitleView = UIView()
        tableTitleView.backgroundColor = .clear
        
        self.scrollView.addSubview(tableTitleView)
        
        tableTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableTitleView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
                                     tableTitleView.widthAnchor.constraint(equalToConstant: 200),
                                     tableTitleView.topAnchor.constraint(equalTo: self.cardView.bottomAnchor, constant: 10),
                                     tableTitleView.heightAnchor.constraint(equalToConstant: 30)])
        
        let tableTitle = UILabel()
        tableTitle.text = "Trending Now"
        tableTitle.font = UIFont.systemFont(ofSize: 20)
//        tableTitle.font = UIFont(name: "Old London", size: 20)
        
        tableTitleView.addSubview(tableTitle)
        tableTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableTitle.leadingAnchor.constraint(equalTo: self.tableTitleView.leadingAnchor, constant: 5),
                                     tableTitle.centerYAnchor.constraint(equalTo: self.tableTitleView.centerYAnchor, constant: 0)])
    }
    private func addCardView() {
        
        cardView = CardView()
        
        self.scrollView.addSubview(cardView)
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cardView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 20),
                                     cardView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40),
                                     cardView.topAnchor.constraint(equalTo: self.cardTitleView.bottomAnchor, constant: 10),
                                     cardView.heightAnchor.constraint(equalToConstant: 200)])
        
    }
    func addTableView() {
        
        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10),
                                     tableView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 40),
                                     tableView.topAnchor.constraint(equalTo: self.tableTitleView.bottomAnchor, constant: 10),
                                     tableView.heightAnchor.constraint(equalToConstant: 636 - 40)])
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.NewsCell, for: indexPath) as! NewsCell
        
        if titles.count != 0 {
            cell.passDataToNewsCell(title: titles[indexPath.row], imageUrl: imagesUrls[indexPath.row],content: contents[indexPath.row])
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        let childVC = ArticleDetailsViewController()
//
//        childVC.content = contents[indexPath.row]
//
//        addChild(childVC)
//        self.view.addSubview(childVC.view)
//        childVC.didMove(toParent: self)
//
//        let childView = childVC.view
//        childView?.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([childView!.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
//                                     childView!.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
//                                     childView!.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0),
//                                     childView!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0)])
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}
extension MainViewController: NewsModelDelegate {
    func didFetchData(json: JSON) {
        
        titles = json["articles"].arrayValue.map {$0["title"].stringValue}
        contents = json["articles"].arrayValue.map {$0["content"].stringValue}
        imagesUrls = json["articles"].arrayValue.map {$0["urlToImage"].stringValue}
        
        cardView.updateCards(titles: titles)
        
        tableView.reloadData()
    }
    
    
}
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollVelocity = Double(abs(velocity.y))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        
        if scrollView == self.scrollView {
            if yOffset >= scrollView.contentSize.height - 636 {
                scrollView.isScrollEnabled = false
                tableView.isScrollEnabled = true
            }
        }
        if scrollView == self.tableView {
            if yOffset <= 0 {
                self.scrollView.isScrollEnabled = true
                self.tableView.isScrollEnabled = false
                UIView.animate(withDuration: 0.5/scrollVelocity) {
                    self.scrollView.contentOffset.y = 0
                }
            }
        }
    }
    
}

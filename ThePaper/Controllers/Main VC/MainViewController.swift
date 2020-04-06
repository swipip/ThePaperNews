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
    private var cardView: CardsVC!
    private var scrollVelocity = 1.0
    
    private lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentSize.height = 636 + 260
        view.backgroundColor = .clear
        return view
    }()
    
    //Data
    private let k = K()
    private let newsModel = NewsModel()
    private var titles = [String]()
    private var imagesUrls = [String]()
    private var articleURL = [String]()
    
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
        
        let name = Notification.Name(K.shared.locationChangeNotificationName)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateNewsWithCountry(_:)), name: name, object: nil)
        
    }
    @objc private func updateNewsWithCountry(_ notification: NSNotification) {
        
        newsModel.fetchData()
        
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
    fileprivate func addTitleHighLighters(_ cardTitle: UILabel) {
        let highlighter = UIView()
        highlighter.backgroundColor = k.mainColorTheme
        
        self.view.addSubview(highlighter)
        
        
        //view
        let fromView = highlighter
        //relative to
        let toView = cardTitle
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.widthAnchor.constraint(equalToConstant: 150),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 2),
                                     fromView.heightAnchor.constraint(equalToConstant: 3)])
    }
    
    fileprivate func addCardTitle() {
        //Breaking news
        cardTitleView = UIView()
        cardTitleView.backgroundColor = .clear
        
        self.scrollView.addSubview(cardTitleView)
        
        cardTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cardTitleView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10),
                                     cardTitleView.widthAnchor.constraint(equalToConstant: 200),
                                     cardTitleView.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: 10),
                                     cardTitleView.heightAnchor.constraint(equalToConstant: 30)])
        
        let cardTitle = UILabel()
        cardTitle.text = "A la Une"
        cardTitle.font = UIFont.systemFont(ofSize: K.shared.fontSizeSubTitle)
        //        cardTitle.font = UIFont(name: "Old London", size: 20)
        
        cardTitleView.addSubview(cardTitle)
        cardTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cardTitle.leadingAnchor.constraint(equalTo: self.cardTitleView.leadingAnchor, constant: 5),
                                     cardTitle.centerYAnchor.constraint(equalTo: self.cardTitleView.centerYAnchor, constant: 0)])
        
        addTitleHighLighters(cardTitle)
        
    }
    fileprivate func addTableTitle() {
        
        let width = self.view.frame.width - 20
        
        //Trending Now
        tableTitleView = UIView()
        tableTitleView.backgroundColor = .clear
        
        self.scrollView.addSubview(tableTitleView)
        
        tableTitleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableTitleView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10),
                                     tableTitleView.widthAnchor.constraint(equalToConstant: width),
                                     tableTitleView.topAnchor.constraint(equalTo: self.cardView.view.bottomAnchor, constant: 0),
                                     tableTitleView.heightAnchor.constraint(equalToConstant: 30)])
        
        let tableTitle = UILabel()
        tableTitle.text = "En Tendance"
        tableTitle.font = UIFont.systemFont(ofSize: 20)
//        tableTitle.font = UIFont(name: "Old London", size: 20)
        
        tableTitleView.addSubview(tableTitle)
        tableTitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableTitle.leadingAnchor.constraint(equalTo: self.tableTitleView.leadingAnchor, constant: 5),
                                     tableTitle.centerYAnchor.constraint(equalTo: self.tableTitleView.centerYAnchor, constant: 0)])
        
        addTitleHighLighters(tableTitle)
        
    }
    private func addCardView() {
        
        cardView = CardsVC()
        cardView.delegate = self
        self.addChild(cardView)
        cardView.willMove(toParent: self)
        let cardViewView = cardView.view!
        
        self.scrollView.addSubview(cardViewView)
        
        cardViewView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([cardViewView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
                                     cardViewView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width),
                                     cardViewView.topAnchor.constraint(equalTo: self.cardTitleView.bottomAnchor, constant: 0),
                                     cardViewView.heightAnchor.constraint(equalToConstant: 220)])
        
    }
    func addTableView() {

        tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        self.scrollView.addSubview(tableView)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([tableView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 0),
                                     tableView.widthAnchor.constraint(equalToConstant: self.view.frame.size.width - 20),
                                     tableView.topAnchor.constraint(equalTo: self.tableTitleView.bottomAnchor, constant: 10),
                                     tableView.heightAnchor.constraint(equalToConstant: 636 - 40)])
    }
}
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfCells = 0
        if titles.count == 0 {
            numberOfCells = 10
        }else{
            numberOfCells = titles.count
        }
        return numberOfCells
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
extension MainViewController: NewsModelDelegate {
    func didFetchData(json: JSON) {
        
        titles = json["articles"].arrayValue.map {$0["title"].stringValue}
        articleURL = json["articles"].arrayValue.map {$0["url"].stringValue}
        imagesUrls = json["articles"].arrayValue.map {$0["urlToImage"].stringValue}
        
        var articles = [Article]()
        
        for (i,title) in titles.enumerated() {
            
            let article = Article(title: title, url: articleURL[i], imageUrl: imagesUrls[i])

            articles.append(article)
        }
        
        cardView.updateCards(articles: articles)
        
        for i in 0..<10 {
            titles.remove(at: i)
            articleURL.remove(at: i)
            imagesUrls.remove(at: i)
        }
        
        tableView.reloadData()
    }
    
    
}
extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollVelocity = Double(abs(velocity.y))
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yOffset = scrollView.contentOffset.y
        if yOffset < -100 {
            tableView.reloadData()
            newsModel.fetchData()
        }
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
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
}

extension MainViewController: CardVCDelegate {
    func didTapCard(url: String) {
        
        let childVC = ArticleDetailsViewController()
        childVC.articleURL = url

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

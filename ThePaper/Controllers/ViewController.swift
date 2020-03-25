//
//  ViewController.swift
//  ThePaper
//
//  Created by Gautier Billard on 16/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    private var tabBar: TabBar!
    private var titleBar: UIView!
    private var layout = UICollectionViewFlowLayout()
    private var collectionViewNav: UICollectionView!
    private let cellID = "cellID"
    private var languageButton: UIButton!
    
    private var k = K()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTitleBar()
        
        tabBar = TabBar(frame: CGRect(x: 0, y: self.view.frame.size.height - 89, width: self.view.frame.size.width, height: 90))
        tabBar.startPoint = 1
        tabBar.delegate = self
        
        self.view.addSubview(tabBar)
        
        addCollectionView()
        
        addLanguageButton()
    }
    private func addLanguageButton() {
        

        
    }
    func addCollectionView() {
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0.0
        
        collectionViewNav = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collectionViewNav.backgroundColor = .clear
        collectionViewNav.showsHorizontalScrollIndicator = false
        collectionViewNav.delegate = self
        collectionViewNav.dataSource = self
        collectionViewNav.isScrollEnabled = false
        
        self.view.insertSubview(collectionViewNav, at: 0)
        
        collectionViewNav.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([collectionViewNav.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0),
                                     collectionViewNav.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0),
                                     collectionViewNav.topAnchor.constraint(equalTo: self.titleBar.bottomAnchor, constant: 0),
                                     collectionViewNav.bottomAnchor.constraint(equalTo: self.tabBar.topAnchor, constant: 0)])
        
        collectionViewNav.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        
    }
    func addTableView() {
        
    }
    func addTitleBar() {
        titleBar = UIView()
        titleBar.frame.origin = CGPoint(x: -1, y: -1)
        titleBar.frame.size = CGSize(width: self.view.frame.size.width + 2, height: 88)
        titleBar.backgroundColor = .clear
        titleBar.layer.borderColor = k.strokeColor.cgColor
        titleBar.layer.borderWidth = 1
        
        self.view.addSubview(titleBar)
        
        let titleLabel = UILabel()
        titleLabel.text = "The Paper"
        titleLabel.font = UIFont(name: "OldLondon", size: 33)
        
        titleBar.addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor, constant: 17),
                                     titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)])
        
        languageButton = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25)
        languageButton.setImage(UIImage(systemName: "globe", withConfiguration: config), for: .normal)
        languageButton.tintColor = k.strokeColor
        
        self.view.addSubview(languageButton)
        
        //view
        let fromView = languageButton!
        //relative to
        let toView = self.titleBar!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.widthAnchor.constraint(equalToConstant: 25),
                                     fromView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 25)])
        
        languageButton.addTarget(self, action: #selector(languagePressed(_:)), for: .touchUpInside)
        
        
    }
    @IBAction func languagePressed(_ sender: UIButton!) {
        
        print("pressed")
        
        let vc = MapViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
extension ViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    fileprivate func addChildVC(_ childVC: UIViewController, _ cell: UICollectionViewCell) {
        addChild(childVC)
        cell.addSubview(childVC.view)
        childVC.didMove(toParent: self)
        
        let childView = childVC.view
        childView?.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([childView!.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 0),
                                     childView!.trailingAnchor.constraint(equalTo: cell.trailingAnchor, constant: 0),
                                     childView!.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0),
                                     childView!.bottomAnchor.constraint(equalTo: cell.bottomAnchor, constant: 0)])
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.subviews.forEach({$0.removeFromSuperview()})
        
        switch indexPath.row {
        case 0:
            let childVC = MainViewController()
            addChildVC(childVC, cell)
        case 1:
            let childVC = SourcesVC()
            addChildVC(childVC, cell)
        case 2:
            let childVC = SearchViewController()
            addChildVC(childVC, cell)
        default:
            cell.backgroundColor = .white
        }

        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionViewNav.frame.size
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tabBar.startPoint = indexPath.row + 1
        tabBar.animateShape()
    }
    
}

extension ViewController: TabBarDelegate {
    
    func buttonPressed(rank: Int) {
        collectionViewNav.selectItem(at: IndexPath(item: rank - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
}



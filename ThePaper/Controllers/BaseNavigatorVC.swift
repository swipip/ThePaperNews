//
//  BaseVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 16/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import SwiftyJSON
import Firebase

class BaseNavigatorVC: UIViewController {
    
    private var tabBar: TabBar!
    private var titleBar: UIView!
    private var layout = UICollectionViewFlowLayout()
    private var collectionViewNav: UICollectionView!
    private let cellID = "cellID"
    private var languageButton: UIButton!
    private var settingButton: UIButton!
    
    private var k = K()
    
    override func viewDidLoad() {
        
        defaults.set(true, forKey: K.shared.loggedIn)
        defaults.set(true, forKey: K.shared.didGetOB)
        if defaults.array(forKey: K.shared.user) == nil {
            let email = Auth.auth().currentUser?.email!
            defaults.set(email, forKey: K.shared.user)
        }
        
         
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(named: "mainColorBackground")
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        addTitleBar()
        
        let navBarHeight:CGFloat = getTitleBarHeight() == 88 ? 90 : 70
        
        tabBar = TabBar(frame: CGRect(x: 0, y: self.view.frame.size.height - navBarHeight + 1 , width: self.view.frame.size.width, height: navBarHeight))
        tabBar.startPoint = 1
        tabBar.delegate = self
        tabBar.factor = getTitleBarHeight() == 64 ? 0.55 : 0.45
        
        self.view.addSubview(tabBar)
        
        addCollectionView()
        
        addLanguageButton()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
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
    func getTitleBarHeight() -> CGFloat {
        
        var titleBarHeight:CGFloat = 0.0
        
        let height = self.view.frame.size.height
        let width = self.view.frame.size.width
        
        let ratio = height/width
        
        if ratio > 1.8 {
            titleBarHeight = 88
        }else{
            titleBarHeight = 64
        }
        
        return titleBarHeight
        
    }
    func addTitleBar() {
        
//        let height =
        
        titleBar = UIView()
        titleBar.frame.origin = CGPoint(x: -1, y: -1)
        titleBar.frame.size = CGSize(width: self.view.frame.size.width + 2, height: getTitleBarHeight())
        titleBar.backgroundColor = K.shared.mainColorTheme//.clear
//        titleBar.layer.borderColor = k.strokeColor.cgColor
//        titleBar.layer.borderWidth = 1
        
        self.view.addSubview(titleBar)
        
        let titleLabel = UILabel()
        titleLabel.text = "The Paper"
        titleLabel.textColor = .white
        titleLabel.font = UIFont(name: "OldLondon", size: 33)
        
        titleBar.addSubview(titleLabel)
        
        let centerYadj:CGFloat = getTitleBarHeight() == 64 ? 6 : 17
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([titleLabel.centerYAnchor.constraint(equalTo: titleBar.centerYAnchor, constant: centerYadj),
                                     titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor, constant: 0)])
        //Country Button
        languageButton = UIButton()
        var config = UIImage.SymbolConfiguration(pointSize: 25)
        languageButton.setImage(UIImage(systemName: "globe", withConfiguration: config), for: .normal)
        languageButton.tintColor = .white//k.strokeColor
        
        self.view.addSubview(languageButton)
        
        //view
        var fromView = languageButton!
        //relative to
        var toView = self.titleBar!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.widthAnchor.constraint(equalToConstant: 25),
                                     fromView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 25)])
        
        languageButton.addTarget(self, action: #selector(languagePressed(_:)), for: .touchUpInside)
        
        //Settings button
        settingButton = UIButton()
        config = UIImage.SymbolConfiguration(pointSize: 25)
        settingButton.setImage(UIImage(systemName: "gear", withConfiguration: config), for: .normal)
        settingButton.tintColor = .white//k.strokeColor
        
        self.view.addSubview(settingButton)
        
        //view
        fromView = settingButton!
        //relative to
        toView = self.titleBar!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.widthAnchor.constraint(equalToConstant: 25),
                                     fromView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 25)])
        
        settingButton.addTarget(self, action: #selector(settingsPressed(_:)), for: .touchUpInside)
    }
    @IBAction func languagePressed(_ sender: UIButton!) {
        
        let vc = MapViewController()
        self.present(vc, animated: true, completion: nil)
        
    }
    @IBAction private func settingsPressed(_ sender:UIButton!) {
        
        
        let vc = UserSettingsVC()
        vc.delegate = self
        self.present(vc, animated: true, completion: nil)
        
    }
    
}
extension BaseNavigatorVC: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIScrollViewDelegate {
    
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
        case 3:
            let childVC = UserVC()
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

extension BaseNavigatorVC: TabBarDelegate {
    
    func buttonPressed(rank: Int) {
        
        if rank == 3 {
            
            let name = Notification.Name(K.shared.cvcSelectionNotifName)
            NotificationCenter.default.post(name: name, object: nil)
            
        }
        
        collectionViewNav.selectItem(at: IndexPath(item: rank - 1, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    
}
extension BaseNavigatorVC: UserSettingsDelegate {
    func didLogOut() {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


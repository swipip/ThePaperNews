//
//  SourcesVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 24/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class SourcesVC: UIViewController {

    private var collectionView: UICollectionView!
    private var images = ["le-monde","les-echos","liberation","lequipe"]
    private var mediaNames = ["le-monde": "Le Monde", "les-echos":"Les Echos","liberation":"Libération","lequipe":"L'Equipe"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getmediaForCountry()
        
        
        addCollectionView()
        
        addObservers()
        
    }
    private func addObservers() {
        let notificationName = Notification.Name(rawValue: K.shared.locationChangeNotificationName)
        NotificationCenter.default.addObserver(self, selector: #selector(updateMedia), name: notificationName, object: nil)
    }
    @objc private func  updateMedia() {
        getmediaForCountry()
        self.collectionView.reloadData()
    }
    fileprivate func getmediaForCountry() {
        let countryCode = localISOCode
        print(countryCode)
        switch countryCode {
        case "gb":
            images = K.shared.gb().images
            mediaNames = K.shared.gb().mediaNames
        case "cn":
            images = K.shared.zh().images
            mediaNames = K.shared.zh().mediaNames
        case "de":
            images = K.shared.de().images
            mediaNames = K.shared.de().mediaNames
        case "it":
            images = K.shared.it().images
            mediaNames = K.shared.it().mediaNames
        case "us":
            images = K.shared.us().images
            mediaNames = K.shared.us().mediaNames
        default:
            break
        }
    }
    fileprivate func addCollectionView() {
        let spacing:CGFloat = 10.0
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cellID")
        
        self.view.addSubview(collectionView)
        
        //view
        let fromView = collectionView!
        //relative to
        let toView = self.view!
        
        fromView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor, constant: -10)])
    }


}
extension SourcesVC: UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellID", for: indexPath)
        
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.image = UIImage(named: images[indexPath.row])
        cell.addSubview(imageView)
        
        //view
        let fromView = imageView
        //relative to
        let toView = cell
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor,constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.width) / 2 - 15
        let height = width * 1.25
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let media = images[indexPath.row]
        let mediaName = mediaNames[media]
        
        let cvc = TableVC()
        cvc.hasATitleBar = true
        cvc.urlString = "https://newsapi.org/v2/top-headlines?sources=\(media)"
        cvc.mediaName = mediaName
        
        addChild(cvc)
        cvc.didMove(toParent: self)
        self.view.addSubview(cvc.view)
        
        //view
        let fromView = cvc.view!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
    }
}

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
    private let images = ["le-monde","les-echos"]
    private let mediaNames = ["le-monde": "Le Monde", "les-echos":"Les Echos"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
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
        let height = width
        
        let size = CGSize(width: width, height: height)
        
        return size
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let media = images[indexPath.row]
        let mediaName = mediaNames[media]
        
        let cvc = TableVC()
        
        cvc.urlString = "https://newsapi.org/v2/top-headlines?sources=\(media)&apiKey="
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

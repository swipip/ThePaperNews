//
//  CardsVC.swift
//  CardView2
//
//  Created by Gautier Billard on 31/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import NaturalLanguage
protocol CardVCDelegate {
    func didTapCard(url: String)
}
class CardsVC: UIViewController {

    var collectionView: UICollectionView!
    
    private var titles: [String]?
    private var urls: [String]?
    private var images: [String]?
    
    var delegate: CardVCDelegate?
    
    struct CellsID {
        static let reusableCellID = "CellID"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addCollectionView()
    }
    override func viewDidAppear(_ animated: Bool) {
        let indexPath = IndexPath(item: 2, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .centeredHorizontally)
    }
    func updateCards(articles: [Article]) {
        
        titles = [String]()
        urls = [String]()
        images = [String]()
        
        for article in articles {
            titles!.append(article.title)
            
            let imageName = performIdentification(for: article.title)
            images!.append(imageName)
            
            urls!.append(article.url)
        }

        collectionView.reloadData()
        
    }
    private func performIdentification(for string: String) -> String{
        do {
            let catClassifier = try NLModel(mlModel: categoryClassifierV31().model)
            let prediction = catClassifier.predictedLabel(for: string)
            return prediction ?? "default"
        } catch {
            print("error with ML model")
            return "default"
        }
    }
    private func addCollectionView() {
        
        let layout = SnappingCollectionViewLayoutWithOffset()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.decelerationRate = .fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = K.shared.mainColorBackground
        collectionView.register(CardCell.self, forCellWithReuseIdentifier: CellsID.reusableCellID)
        
        self.view.addSubview(collectionView)
        
        //view
        let fromView = collectionView!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
    }
}
extension CardsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        #warning("Must return a computed number of cells")
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let index = indexPath.row
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellsID.reusableCellID, for: indexPath) as! CardCell
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        cell.addGestureRecognizer(tapGesture)
        
        cell.backgroundColor = .white
        
        if let title = titles?[index], let url = urls?[index], let imageName = images?[index] {
            let imageName = imageName
            cell.updateCard(title: title, imageName: imageName, url: url)
        }
        
        return cell
        
    }
    @objc
    private func cardTapped(_ recognizer: UITapGestureRecognizer) {
        
        if let view = recognizer.view as? CardCell {
            delegate?.didTapCard(url: view.url!)
        }

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = CGSize(width: self.view.frame.size.width - 70, height: self.view.frame.size.height)
        
        return size
    }
    
    
    
}
class SnappingCollectionViewLayoutWithOffset: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left + 35

        let targetRect = CGRect(x: proposedContentOffset.x, y: 0, width: collectionView.bounds.size.width, height: collectionView.bounds.size.height)

        let layoutAttributesArray = super.layoutAttributesForElements(in: targetRect)

        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })

        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}


//
//  OnBoardingVC.swift
//  OnBoardingThePaper
//
//  Created by Gautier Billard on 29/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

protocol OnBoardingVCDelegate {
    func didFinishChoosingPreferences(preferences: [String])
}

class customCell: UICollectionViewCell {
    var category: String = ""
}

class OnBoardingVC: UIViewController {

    private var collectionIndex = 0
    private var preferences = [String]()
    private var buttons = [UIButton]()
    
    //data
    var delegate: OnBoardingVCDelegate?
    
    struct CellID {
        static let reusableCellID = "CellID"
    }
    
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "The Paper"
        
        self.view.backgroundColor = .clear
        
        addBackground()
        addCollectionView()
        addTitle()
        addConfirmationButtons()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.hidesBackButton = true
        self.navigationController?.navigationItem.backBarButtonItem?.isEnabled = false
    }
    private func addBackground() {
        
        let imageView = UIImageView(image: UIImage(named: "backgroundOB"))
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        //view
        let fromView = imageView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
    }
    private func addTitle() {
        
        let titleBackground = UIView()
        titleBackground.backgroundColor = .white
        titleBackground.addShadow(radius: 5, color: .gray, opacity: 0.4)
        
        self.view.addSubview(titleBackground)
        
        //view
        var fromView = titleBackground
        //relative to
        let toView = collectionView!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
                                     fromView.bottomAnchor.constraint(equalTo: toView.topAnchor,constant: 5)])
        
        titleBackground.layer.cornerRadius = 8//titleBackground.frame.size.height / 2
        
        let title = UILabel()
        title.text = "What is interesting to you?"
        title.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        title.textAlignment = .center
        title.numberOfLines = 0
        
        self.view.addSubview(title)
        
        //view
        fromView = title
        //relative to
        let toViewTwo = titleBackground
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toViewTwo.centerXAnchor, constant: 0),
                                     fromView.centerYAnchor.constraint(equalTo: toViewTwo.centerYAnchor, constant: 0),
                                     fromView.widthAnchor.constraint(equalToConstant: 200)])
        
    }
    private func addConfirmationButtons() {
        
        let images = ["checkmark","xmark"]
        let centerXConstr:[CGFloat] = [-60,60]
        let colors: [UIColor] = [UIColor(red: 81/255, green: 191/255, blue: 136/255,alpha: 1), UIColor(red: 255/255, green: 96/255, blue: 111/255,alpha: 1)]
        
        for i in 0...1 {
            let button = UIButton()
            let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold)
            button.setImage(UIImage(systemName: images[i],withConfiguration: configuration), for: .normal)
            button.backgroundColor = .white
            button.tintColor = colors[i]
            button.layer.cornerRadius = 30
            button.addShadow(radius: 5, color: .gray, opacity: 0.5)
            
            self.view.addSubview(button)
            
            //view
            let fromView = button
            //relative to
            let toView = self.collectionView!
                
            fromView.translatesAutoresizingMaskIntoConstraints = false
            
            NSLayoutConstraint.activate([fromView.centerXAnchor.constraint(equalTo: toView.centerXAnchor, constant: centerXConstr[i]),
                                         fromView.widthAnchor.constraint(equalToConstant: 60),
                                         fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 20),
                                         fromView.heightAnchor.constraint(equalToConstant: 60)])
            
            button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            
            buttons.append(button)
        }
        

        
    }
    @IBAction
    func buttonPressed(_ sender: UIButton!) {
        
        if collectionIndex <= 8 {
            var indexPath = IndexPath(item: collectionIndex, section: 0)
            
            if sender == buttons[0] {
                let cell = collectionView.cellForItem(at: indexPath) as! customCell
                preferences.append(cell.category)
//                print(preferences)
            }
            
            collectionIndex += 1
            
            indexPath.item = collectionIndex
            
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        if collectionIndex > 8 {
            delegate?.didFinishChoosingPreferences(preferences: preferences)
        }
        
    }
    func addCollectionView() {
        
        let layout = SnappingCollectionViewLayout()
        layout.minimumLineSpacing = 0.0
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(customCell.self, forCellWithReuseIdentifier: CellID.reusableCellID)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = .clear
        
        self.view.addSubview(collectionView)
        
        
        //view
        let fromView = collectionView!
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 170),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -150)])
        
    }

}
extension OnBoardingVC: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let categories = ["Politique","Technologie","Economie","Santé","Sport","People","Meteo","Faits-divers","Monde"]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellID.reusableCellID, for: indexPath) as! customCell
        cell.subviews.forEach {$0.removeFromSuperview()}
        
        cell.category = categories[indexPath.row]
        
        let vc = CollectionViewCellVC()
        vc.category = categories[indexPath.row]
        
        addChild(vc)
        
        cell.addSubview(vc.view)
        
        //view
        let fromView = vc.view!
        
        let toView = cell
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: 0)])
        
        return cell
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return size
    }
    
}
class SnappingCollectionViewLayout: UICollectionViewFlowLayout {

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = collectionView else { return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity) }

        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        let horizontalOffset = proposedContentOffset.x + collectionView.contentInset.left

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
extension UIView {
    
    func addShadow(radius: CGFloat,color: UIColor,opacity: Float) {
        self.layer.shadowColor = color.cgColor
        self.layer.shadowRadius = radius
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
    
}


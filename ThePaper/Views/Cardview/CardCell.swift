//
//  CardCell.swift
//  CardView2
//
//  Created by Gautier Billard on 31/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class CardCell: UICollectionViewCell {
    
    //Data
    var url: String?
    //UI
    private lazy var cardBackground: UIView = {
        let cardBackground = UIView()
        cardBackground.backgroundColor = .white//K.shared.mainColorTheme
        cardBackground.layer.cornerRadius = 8
        cardBackground.layer.masksToBounds = true
//        cardBackground.addShadow(radius: 6, color: .lightGray, opacity: 0.6)
        return cardBackground
    }()
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.text = "Fetching data..."
        label.numberOfLines = 3
        label.font = UIFont.systemFont(ofSize: K.shared.fontSizeContent)
        label.textColor = .black//.white
        return label
    }()
    private var backgroundImage: UIImageView!
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    override init(frame: CGRect) {
         super.init(frame: frame)

        addCardBackground()
        addTitle()
        addImageBackground()
        addImage()

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addImageBackground() {
        
        backgroundImage = UIImageView()
        backgroundImage.image = UIImage(named: "cardBackground" )
        backgroundImage.contentMode = .scaleAspectFill
        
        self.addSubview(backgroundImage)
        
        //view
        let fromView = backgroundImage!
        //relative to
        let toView = self.cardBackground
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor,constant: -5)])
        
    }
    func updateCard(title: String, imageName: String ,url: String) {
        
        if imageName == "Technologie" {
            backgroundImage.image = UIImage(named: "cardBackground2" )
        }
        
        imageView.image = UIImage(named: imageName)
        titleLabel.text = title
        self.url = url
        
    }
    private func addCardBackground() {
        
        self.addSubview(cardBackground)
        
        //view
        let fromView = cardBackground
        //relative to
        let toView = self
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 8),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -8),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 15),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -10)])
        
        let shadowView = UIView()
        shadowView.backgroundColor = .white
        shadowView.layer.cornerRadius = 8
        shadowView.addShadow(radius: 8, color: .lightGray, opacity: 0.6)
        self.insertSubview(shadowView, at: 1)
            
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([shadowView.leadingAnchor.constraint(equalTo: cardBackground.leadingAnchor, constant: 5),
                                     shadowView.trailingAnchor.constraint(equalTo: cardBackground.trailingAnchor, constant: -5),
                                     shadowView.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 5),
                                     shadowView.bottomAnchor.constraint(equalTo: cardBackground.bottomAnchor,constant: -5)])
        
        
    }
    private func addTitle() {
        
        self.addSubview(titleLabel)
        
        //view
        let fromView = titleLabel
        //relative to
        let toView = cardBackground
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -7),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -5),
                                     fromView.heightAnchor.constraint(equalToConstant: 70)])
        
    }
    private func addImage() {
        
        self.addSubview(imageView)
        
        //view
        let fromView = imageView
        //relative to
        let toView = titleLabel
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: -10),
                                     fromView.widthAnchor.constraint(equalToConstant: 150),
                                     fromView.topAnchor.constraint(equalTo: cardBackground.topAnchor, constant: 10),
                                     fromView.bottomAnchor.constraint(equalTo: toView.topAnchor,constant: -10)])
    }
}

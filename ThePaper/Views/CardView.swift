//
//  CardView.swift
//  NewsCard
//
//  Created by Gautier Billard on 06/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

class CardView: UIView {
    
    private var cards = [UIView]()
    private var cardsCenterConstraints = [NSLayoutConstraint]()
    private let position = [-30,-25,0]
    private let scale = [0.8,0.9,1]
    private let colors = [UIColor.systemBlue,UIColor.systemGreen,UIColor.systemPink]
    private var swipeCount = 0
    private var newsCount = 0
    var x = 1.0
    private var k = K()
    private var titleLabel = [UILabel]()
    private var titleLabelsPH = [UIView]()
    private var imageView = [UIImageView]()
    private var awayCardConstraint: NSLayoutConstraint!
    private var awayCard: UIView!
    private var awayCardHighlight: UIView!
    
    private var titles:[String]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    func commonInit() {
//        Addcard()
    }
    override func draw(_ rect: CGRect) {
        
        self.subviews.forEach({$0.removeFromSuperview()})
        titleLabel.removeAll()
        titleLabelsPH.removeAll()
        imageView.removeAll()
        cardsCenterConstraints.removeAll()
        cards.removeAll()
        
        awayCardHighlight = UIView(frame: CGRect(x: self.frame.width - 30, y: 0, width: 30, height: self.frame.size.height))
        awayCardHighlight.layer.cornerRadius = 12
        awayCardHighlight.backgroundColor = .lightGray
        awayCardHighlight.alpha = 0.0
        
        self.addSubview(awayCardHighlight)
        
        insertNewCard()
        insertNewCard()
        insertNewCard()
    }
    func updateCards(titles: [String]) {
        
        self.titles = titles
        
        for (i,label) in titleLabel.enumerated() {
            label.text = titles[i]
        }
        
        titleLabelsPH.forEach({$0.alpha = 0.0})
    }
    private func layoutCard(card: UIView) {
        
        let titlePH = UIView()
        titlePH.backgroundColor = .systemRed
        titlePH.layer.cornerRadius = 12
        
        if titles?[newsCount] == nil {
            
            card.addSubview(titlePH)
            
            titleLabelsPH.append(titlePH)
            
            titlePH.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([titlePH.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
                                         titlePH.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -80),
                                         titlePH.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10),
                                         titlePH.heightAnchor.constraint(equalToConstant: 30)])
            
        }
        
        let newTitleLabel = UILabel()
        newTitleLabel.textColor = .white
        newTitleLabel.text = titles?[newsCount] ?? ""
        newTitleLabel.numberOfLines = 3
        newTitleLabel.font = UIFont.systemFont(ofSize: 20)
        
        card.addSubview(newTitleLabel)
        
        newTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([newTitleLabel.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),newTitleLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -10),
                                     newTitleLabel.bottomAnchor.constraint(equalTo: card.bottomAnchor, constant: -10)])
        
        titleLabel.insert(newTitleLabel, at: 0)
        
        let newImage = UIImageView()
        newImage.image = UIImage(named: "medicine")
        
        card.addSubview(newImage)
        
        newImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([newImage.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 10),
                                     newImage.widthAnchor.constraint(equalToConstant: 100),
                                     newImage.bottomAnchor.constraint(equalTo: newTitleLabel.topAnchor, constant: -10),
                                     newImage.heightAnchor.constraint(equalToConstant: 100)])
    }
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self)
        let factor = [0.1,0.2,1]
        var delay = 0.0
        
        var xOrigin:CGFloat = 0.0
        
        switch recognizer.state {
        case.began:
            xOrigin = (recognizer.view?.frame.origin.x)!
        case .ended:
            x = 1
            if recognizer.view!.frame.origin.x < xOrigin{
                
                //return previous card
                if let awayCard = self.awayCard {
                    cards.first!.removeFromSuperview()
                    cards.removeFirst()
                    cardsCenterConstraints.removeFirst()
                    
                    cards.append(awayCard)
                    cardsCenterConstraints.append(awayCardConstraint)
                    
                    self.addSubview(awayCard)
                    
                    for (i,card) in cards.enumerated(){
                        
                        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
                            
                            card.transform = CGAffineTransform(scaleX: CGFloat(self.scale[i]), y: CGFloat(self.scale[i]))
                            self.cardsCenterConstraints[i].constant = CGFloat(self.position[i])
                            self.awayCardHighlight.alpha = 0.0
                            
                            self.awayCardConstraint.constant = CGFloat(self.position[i])
                            self.layoutIfNeeded()
                            
                        }, completion: {(_) in
                        })
                        
                        
                        
                    }
                }
            }else if cards.last!.frame.origin.x > self.center.x {
                exitCard()
                insertNewCard()
            }else{
                
                for (i,card) in cards.enumerated(){
                    
                    UIView.animate(withDuration: 0.3, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                        self.awayCardHighlight.alpha = 0.0
                        card.transform = CGAffineTransform(scaleX: CGFloat(self.scale[i]), y: CGFloat(self.scale[i]))
                        self.cardsCenterConstraints[i].constant = CGFloat(self.position[i])
                        self.layoutIfNeeded()
                        
                    }, completion: nil)
                    delay += 0.05
                    
                }
            }
            
        
        default:
            x += 0.001
            if recognizer.view!.center.x < self.center.x {
//
//                awayCardHighlight.alpha += abs(translation.x)/10
//                print(abs(translation.x)/100)
            }
            
            for (i,card) in cards.enumerated(){
                if i != 0 {
//                    print(scale.count)
                    let scale = CGFloat(self.scale[i] * (min(x,1)))
                    
                    card.transform = CGAffineTransform(scaleX: scale, y: scale)
                    self.cardsCenterConstraints[i].constant += translation.x * CGFloat(factor[i])
                    
                    self.layoutIfNeeded()
                }
            }
        }
        
        
        
        recognizer.setTranslation(.zero, in: self)
        
    }
    fileprivate func exitCard() {
        if cardsCenterConstraints.count != 0 {
            awayCardConstraint = cardsCenterConstraints.last!
            awayCard = cards.last!
            
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn, animations: {
                self.awayCardConstraint.constant += 300
                self.layoutIfNeeded()
            }, completion: nil)
            
            cards.removeLast()
            cardsCenterConstraints.removeLast()
        }
    }
    
    func insertNewCard() {
        newsCount += 1
        swipeCount += 1
        if swipeCount > colors.count - 1{
            swipeCount -= colors.count
        }
        
        let newCard = UIView()
        newCard.backgroundColor = k.mainColorTheme//colors[swipeCount]
        newCard.layer.cornerRadius = 8
        newCard.alpha = 0
        
        self.insertSubview(newCard, at: 0)
        
        newCard.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([newCard.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
                                     newCard.heightAnchor.constraint(equalToConstant: self.frame.size.height),
                                     newCard.widthAnchor.constraint(equalToConstant: self.frame.size.width)])
        
        let centerConstraint = NSLayoutConstraint(item: newCard, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: CGFloat(position[0]))
        
        self.addConstraint(centerConstraint)
        self.layoutIfNeeded()
        
        cardsCenterConstraints.insert(centerConstraint, at: 0)
        cards.insert(newCard, at: 0)
        
        newCard.transform = CGAffineTransform(scaleX: CGFloat(scale[0]), y: CGFloat(scale[0]))
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        newCard.addGestureRecognizer(panGesture)
        
        layoutCard(card: newCard)
        
        for (i,card) in cards.enumerated(){
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
                card.transform = CGAffineTransform(scaleX: CGFloat(self.scale[i]), y: CGFloat(self.scale[i]))
                card.alpha = CGFloat(1 * self.scale[i])
                self.cardsCenterConstraints[i].constant = CGFloat(self.position[i])
                self.layoutIfNeeded()
            }, completion: {(_) in
                
            })
        }
    }

}

//
//  userPrefCell.swift
//  ThePaper
//
//  Created by Gautier Billard on 01/04/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

class UserPrefCell: UITableViewCell {

    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = .white
        return label
    }()
    lazy var contView: UIView = {
        let view = UIView()
        view.backgroundColor = K.shared.grayTextFieldBackground
        view.layer.cornerRadius = 20
        return view
    }()
    lazy var uncheckedMark: UIImageView = {
        let image = UIImageView()
        image.tintColor = .white
        image.contentMode = .scaleAspectFit
        image.image = UIImage(systemName: "circle")
        return image
    }()
    lazy var markFill: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 7.5
        view.alpha = 0.0
        view.backgroundColor = .systemGreen
        return view
    }()
    
    var cellState:cellStates = .free
    
    enum cellStates {
        case pressed, free
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addBackground()
        addLabel()
        addCheckMark()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addCheckMark() {
        
        self.addSubview(uncheckedMark)
        
        //view
        let fromView = uncheckedMark
        //relative to
        let toView = self
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.widthAnchor.constraint(equalToConstant: 30),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -50),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 30)])
        
        self.uncheckedMark.addSubview(markFill)
        
        //view
        let frView = markFill
        
        let tView = uncheckedMark
            
        frView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([frView.centerXAnchor.constraint(equalTo: tView.centerXAnchor, constant: 0),
                                     frView.widthAnchor.constraint(equalToConstant: 15),
                                     frView.centerYAnchor.constraint(equalTo: tView.centerYAnchor, constant: 0),
                                     frView.heightAnchor.constraint(equalToConstant: 15)])
        
    }
    private func addBackground() {
        
        self.addSubview(contView)
        
        //view
        let fromView = contView
        //relative to
        let toView = self
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor,constant: -20),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 10),
                                     fromView.bottomAnchor.constraint(equalTo:toView.bottomAnchor ,constant: -10)])
        
    }
    private func addLabel() {
        
        self.addSubview(label)
        
        //view
        let fromView = label
        //relative to
        let toView = self
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 40),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0)])
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

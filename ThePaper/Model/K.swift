//
//  K.swift
//  ThePaper
//
//  Created by Gautier Billard on 23/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

struct K {
    
    static let shared = K()
    
    let mainColorTheme: UIColor = UIColor(named: "mainColorTheme")!
    let mainColorBackground: UIColor = UIColor(named: "mainColorBackground")!
    let strokeColor: UIColor = UIColor(named: "strokeColor")!
    let backgroundImage = UIImage(named: "BackGround")
    let backgroundLaunch = UIImage(named: "backgroundLaunch")
    let grayTextFieldBackground = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
    
    let fontSizeSubTitle:CGFloat = 20.0
    let fontSizeContent:CGFloat = 16.0
    
    let loggedIn = "loggedIn"
    let didGetOB = "didGetOB"
    
    let categoriesArray = ["Technologie","Santé","Politique","Economie","Monde","Faits-divers","People","Ecologie","Météo"]
}

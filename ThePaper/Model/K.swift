//
//  K.swift
//  ThePaper
//
//  Created by Gautier Billard on 23/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit

let x = K.shared.fr

struct K {
    
    static let shared = K()
    
    
    
    //Layout
    let mainColorTheme: UIColor = UIColor(named: "mainColorTheme")!
    let mainColorBackground: UIColor = UIColor(named: "mainColorBackground")!
    let strokeColor: UIColor = UIColor(named: "strokeColor")!
    let backgroundImage = UIImage(named: "BackGround")
    let backgroundLaunch = UIImage(named: "backgroundLaunch")
    let grayTextFieldBackground = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 0.2)
    let fontSizeSubTitle:CGFloat = 20.0
    let fontSizeContent:CGFloat = 16.0
    let fontSizeTitle:CGFloat = 23
    
    //Data
    
    func fr() -> (images: [String],mediaNames: [String:String]){
        
        let images = ["le-monde","les-echos","liberation","lequipe"]
        let mediaNames = ["le-monde": "Le Monde", "les-echos":"Les Echos","liberation":"Libération","lequipe":"L'Equipe"]
        
        return (images,mediaNames)
    }
    func gb() -> (images: [String],mediaNames: [String:String]){
        
        let images = ["bbc-news","bbc-sport","business-insider-uk","independent"]
        let mediaNames = ["bbc-news":"BBC News","bbc-sport":"BBC Sport","business-insider-uk":"Business Insider","independent":"Independent"]
        
        return (images,mediaNames)
    }
    func zh() -> (images: [String],mediaNames: [String:String]){
        
        let images = ["xinhua-net"]
        let mediaNames = ["xinhua-net":"Xinhua News"]
        
        return (images,mediaNames)
    }
    func us() -> (images: [String],mediaNames: [String:String]){
        
        let images = ["the-wall-street-journal","business-insider","medical-news-today","national-geographic","the-washington-times","ign","espn"]
        let mediaNames = ["the-wall-street-journal": "WSJ","business-insider":"Business Insider","medical-news-today":"Medical News Today","national-geographic":"National Geographic","the-washington-times":"The Washington Time","ign":"IGN","espn":"ESPN"]
        
        return (images,mediaNames)
    }
    func de() -> (images: [String],mediaNames: [String:String]){
        
        let images = ["bild","der-tagesspiegel","die-zeit"]
        let mediaNames = ["bild":"Bild","der-tagesspiegel":"Der Tagesspiegel","die-zeit":"Die Zeit"]
        
        return (images,mediaNames)
    }
    func it() -> (images: [String],mediaNames: [String:String]){
        
        let images = ["la-repubblica","ansa"]
        let mediaNames = ["la-repubblica":"La Republica","ansa":"ANSA"]
        
        return (images,mediaNames)
    }
    
    let categoriesArray = ["Technologie","Santé","Politique","Economie","Monde","Faits-divers","People","Ecologie","Météo","Sport"]

    
    //User defaults keys
    let loggedIn = "loggedIn"
    let didGetOB = "didGetOB"
    
    //Notification Keys
    let userSettingDidChangeNotificationName = "co.gautierBillard.userSettings"
    let locationChangeNotificationName = "co.gautierBillard.locationkey"
    let cvcSelectionNotifName = "co.gautierBillard.cvcKey"
    
    //Layout
    func getTitleBarHeight(width: CGFloat, height: CGFloat) -> CGFloat {
        
        var titleBarHeight:CGFloat = 0.0
        
        let ratio = height/width
        
        if ratio > 1.8 {
            titleBarHeight = 88
        }else{
            titleBarHeight = 64
        }
        
        return titleBarHeight
        
    }
    
}

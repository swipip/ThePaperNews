//
//  NewsModel.swift
//  ThePaper
//
//  Created by Gautier Billard on 18/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import SwiftyJSON
import Alamofire

protocol  NewsModelDelegate {
    func didFetchData(json: JSON)
}

class NewsModel {
    
    private var keys = Keys()
    
    var jsonDelegate: NewsModelDelegate?

    private var baseUrl = "https://newsapi.org/v2/top-headlines?country="
    
    func fetchData(urlString:String? = nil) {
        
        var safeUrlString = "\(baseUrl)\(localISOCode)"
        
        if let urlString = urlString {
            if urlString != baseUrl {
                safeUrlString = urlString
            }
        }
        
        let urlString = "\(safeUrlString)\(keys.news)"
        
        guard let url = URL(string: urlString) else {
            print("/Newsmodel line 41/ no url")
            return
        }
        
        Alamofire.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                self.jsonDelegate?.didFetchData(json: json)
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
    
}

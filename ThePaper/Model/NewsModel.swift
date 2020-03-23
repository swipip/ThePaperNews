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
    
    private let country = "fr"
    
    var keys = Keys()
    var jsonDelegate: NewsModelDelegate?
    
    
    private func makeUrlString(base: String? = "", country: String) -> String {
        
        let safeString = base == "" ? "https://newsapi.org/v2/top-headlines?country=" : base
        
        let apiKey = "&apiKey="
        
        let string = "\(safeString!)\(country)\(apiKey)"
        
        return string
    }
    
    func fetchData(urlString:String? = "", country:String? = "fr") {
        
        let urlString = urlString == "" ? "\(makeUrlString(base: urlString!, country: country!))\(keys.news)" : "\(urlString!)\(keys.news)"
        
        guard let url = URL(string: urlString) else {
            print("no url")
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

//
//  ImageManager.swift
//  News-SwiftUI
//
//  Created by Gautier Billard on 20/11/2019.
//  Copyright © 2019 Gautier Billard. All rights reserved.
//

import Foundation
import UIKit

protocol ImageManagerDelegate {
    func didFetchImages(codedImage: Data)
    func didReceivedAnErrorWhileLoadingImage()
}

class ImageManager: ObservableObject {
    
    var data = Data()
    var delegate: ImageManagerDelegate?
    
    func loadImages(url: String){
        
        if let url = URL(string: url){
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    self.delegate?.didReceivedAnErrorWhileLoadingImage()
                }else{
                    if let safeData = data {
                        DispatchQueue.main.async{
                            self.data = safeData
                            if let data = data {
                                self.delegate?.didFetchImages(codedImage: data)
                            }
                        }
                    }
                }
            }
            task.resume()
        }else{
//            print("no url")
            self.delegate?.didReceivedAnErrorWhileLoadingImage()
        }
    }
}

//
//  TitleIdentifierModel.swift
//  ThePaper
//
//  Created by Gautier Billard on 31/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import NaturalLanguage

class TitleIdentifierModel {
    
    static let shared = TitleIdentifierModel()
    
    func performIdentification(for string: String) -> String{
        do {
            let catClassifier = try NLModel(mlModel: categoryClassifierV31().model)
            let prediction = catClassifier.predictedLabel(for: string)
            return prediction ?? "default"
        } catch {
            print("error with ML model")
            return "default"
        }
    }
    
}

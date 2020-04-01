//
//  dataBaseManager.swift
//  ThePaper
//
//  Created by Gautier Billard on 01/04/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import Firebase

class DataBaseManager {
    
    static let shared = DataBaseManager()
    
    func savePreferences(_ preferences: [String]) {
        if let user = Auth.auth().currentUser {
            let uid:String = user.email!
            
            for preference in preferences {
                var ref: DocumentReference? = nil
                ref = db.collection("usersPreferences").addDocument(data: [
                    "user": uid,
                    "preference": preference,
                ]) { err in
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        print("Document added with ID: \(ref!.documentID)")
                    }
                }
            }
            
        }
    }
    
}

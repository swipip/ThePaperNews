//
//  dataBaseManager.swift
//  ThePaper
//
//  Created by Gautier Billard on 01/04/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import Firebase
protocol DataBaseManagerDelegate {
    func didFetchData(preferences: [String])
}
class DataBaseManager {
    
    var delegate: DataBaseManagerDelegate?
    
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
    
    func cleanDataForCurrentUser() {
        
        if let user = Auth.auth().currentUser {
            db.collection("usersPreferences").whereField("user", isEqualTo: user.email!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let documents = querySnapshot?.documents
                        documents?.forEach({ (doc) in
                            doc.reference.delete()
                        })
                    }
            }

        }
        
    }
    func erasePreference(preference: String) {
        
        if let user = Auth.auth().currentUser {
            
            db.collection("usersPreferences").whereField("user", isEqualTo: user.email!).whereField("preference", isEqualTo: preference)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        let documents = querySnapshot?.documents
                        documents?.forEach({ (doc) in
                            doc.reference.delete()
                        })
                    }
            }

        }
        
    }
    func loadDataForUser() {
        
        var userPref = [String]()
        
        if let user = Auth.auth().currentUser {
            db.collection("usersPreferences").whereField("user", isEqualTo: user.email!)
                .getDocuments() { (querySnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    } else {
                        for document in querySnapshot!.documents {
                            let data = document.data()
                            if let property = data["preference"] as? String {
                                userPref.append(property)
                            }
                        }
                    }
                    self.delegate?.didFetchData(preferences: userPref)
            }
        }
        
    }
}

//
//  User.swift
//  ThePaper
//
//  Created by Gautier Billard on 28/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import AuthenticationServices

struct User {
    
    let id: String
    let firstName: String
    let lastname: String
    let email: String
    
    init(credentials: ASAuthorizationAppleIDCredential) {
        
        self.id = credentials.user
        self.firstName = credentials.fullName?.givenName ?? ""
        self.lastname = credentials.fullName?.familyName ?? ""
        self.email = credentials.email ?? ""
        
    }
    
}

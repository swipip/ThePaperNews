//
//  AnonymousSignFB.swift
//  ThePaper
//
//  Created by Gautier Billard on 28/03/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import Foundation
import Firebase

struct AnonymousSignFB {
    
    func signIn() {
        Auth.auth().signInAnonymously() { (authResult, error) in
          guard let user = authResult?.user else { return }
          let isAnonymous = user.isAnonymous  // true
          let uid = user.uid
        }
    }

}

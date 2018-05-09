//
//  User.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

struct User{
    
    let uid: String
    let username: String
    let profileImageURL: String
    
    init(uid: String,dictionary: [String: Any]) {
        
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"] as? String ?? ""
    }
}

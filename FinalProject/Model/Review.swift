//
//  Review.swift
//  FinalProject
//
//  Created by Suruchi Singh on 5/2/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

struct Review {
    
    let user: User?
    
    let text: String?
    let uid: String?
    
    init(user: User, dictionary: [String: Any]){
        
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["userId"] as? String ?? ""
        
    }
}

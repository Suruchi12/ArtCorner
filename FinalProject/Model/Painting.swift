//
//  Painting.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/27/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit

struct Painting {
    
    var id: String?
    //var likeCount: Int
    let user: User
    let paintingUrl: String
    let paintingTitle: String
    let creationDate: Date
    
    var hasLiked: Bool = false
    
    init(user: User, dictionary: [String: Any]) {
    
        self.user = user
        self.paintingUrl = dictionary["paintingUrl"] as? String ?? ""
        self.paintingTitle = dictionary["paintingTitle"] as? String ?? ""
        //self.likeCount = dictionary["likeCount"] as? Int ?? 0
        
        let seconds = dictionary["creationDate"] as? Double ?? 0
        self.creationDate = Date(timeIntervalSince1970: seconds)
    }
}

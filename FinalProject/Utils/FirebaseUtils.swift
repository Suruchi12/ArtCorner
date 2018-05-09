//
//  FirebaseUtils.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import Firebase

extension Database{
    
    static func fetchUserUID(uid: String, completion: @escaping (User)-> ()){
        
        print("Fetching user with uid", uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let userDictionary = snapshot.value as? [String: Any] else {return}
            
            //let user = User(dictionary: userDictionary)
            let user = User(uid: uid, dictionary: userDictionary)
            
            completion(user)
            
            //self.fetchPostWithUser(user: user)
            
        }) { (error) in
            
            print("Failed to fetch user", error)
        }
    }
}

//
//  SearchCell.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SearchCell: UICollectionViewCell {
    
    var postCount: Int?
    
    var user: User?{
        didSet{
            userName.text = user?.username
            guard let profileImageURL = user?.profileImageURL else {return}
            profileImage.loadImage(urlString: profileImageURL)
            setPostCount()
        }
    }
    
    func setPostCount(){
        
        guard let user = user else {return}
        let userId = user.uid
        let ref = Database.database().reference().child("painting")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(userId){
                let newRef = Database.database().reference().child("painting").child(userId)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //print("snapshot.childrenCount : \(snapshot.childrenCount)")
                    
                    //self.postCount = Int(snapshot.childrenCount)
                    let postCountString = snapshot.childrenCount
                    let attributedText = NSMutableAttributedString(string: "Posts:  \(postCountString)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)])
                    
                    //attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    
                    self.noOfPosts.attributedText = attributedText
                    
                }, withCancel: nil)
                
            }
            
        }, withCancel: nil)
        
    }
    
    let noOfPosts: UILabel = {
       
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         let attributedText = NSMutableAttributedString(string: "Posts:  \(0)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 12)])
        
        label.attributedText = attributedText
        
        //label.font = UIFont.boldSystemFont(ofSize: 15)
        //label.text = "Posts: "
        return label
    }()
    
    let profileImage: CustomImageView = {
       
        let profileImage = CustomImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.clipsToBounds = true
        profileImage.contentMode = .scaleToFill
        return profileImage
    }()
    
    let userName: UILabel = {
    
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.text = "User Name"
        return label
    }()
    
    let divider: UIView = {
       
        let divider = UILabel()
        divider.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return divider
    }()
    
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        //backgroundColor = .purple
        
        addSubview(profileImage)
        addSubview(userName)
        addSubview(noOfPosts)
        addSubview(divider)
        
        //User Profile Image
        profileImage.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 50, height: 50)
        profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.layer.cornerRadius = 25
        
        //User Name Label
        userName.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: noOfPosts.topAnchor, right: rightAnchor, paddingTop: 2, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //No of Posts
        noOfPosts.anchor(top: userName.bottomAnchor, left: profileImage.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 3, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //divider between cells
        divider.anchor(top: nil, left: userName.leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

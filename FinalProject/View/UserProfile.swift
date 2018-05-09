//
//  UserProfile.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/25/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import Firebase
import UIKit

protocol UserProfileDelegate{
    
    func didEdit()
}

class UserProfile: UIView {
    
    var delegate: UserProfileDelegate?
    
    var postCount: Int = 0
    var userId: String?
    
    var user: User?{
        
        didSet{
            
            guard let profileImageUrl = user?.profileImageURL else {return}
            guard let uid = user?.uid else {return}
            self.userId = uid
            userNameLabel.text = user?.username
            profileImage.loadImage(urlString: profileImageUrl)
           
            setEditFollowButton()
            setPostCount()
            setFollowing()
            setFollowers()
            //setupProfileImage()
        }

    }
    func setFollowers(){
    
        let ref = Database.database().reference().child("followers")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.userId!){
                
                let newRef = Database.database().reference().child("followers").child(self.userId!)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let followersCount = Int(snapshot.childrenCount)
                    let attributedText = NSMutableAttributedString(string: "\(followersCount)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
                    
                    attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    
                    self.followers.attributedText = attributedText
                    
                    //if child is removed
                    newRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                        
                        let followersCount = Int(snapshot.childrenCount)
                        let attributedText = NSMutableAttributedString(string: "\(followersCount)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
                        
                        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                        
                        self.followers.attributedText = attributedText
                        
                    }, withCancel: nil)
                    
                    
                }, withCancel: nil)
            }
    
            
        }, withCancel: nil)
        
        
        
    }
    
    func setFollowing(){
       
        let ref = Database.database().reference().child("following")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.userId!){
                let newRef = Database.database().reference().child("following").child(self.userId!)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //print("snapshot.childrenCount : \(snapshot.childrenCount)")
                    
                    let followingCount = Int(snapshot.childrenCount)
                    let attributedText = NSMutableAttributedString(string: "\(followingCount)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
                    
                    attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    
                    self.following.attributedText = attributedText
                    
                    //if child is removed
                    newRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                        
                        let followingCount = Int(snapshot.childrenCount)
                        let attributedText = NSMutableAttributedString(string: "\(followingCount)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
                        
                        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                        
                        self.following.attributedText = attributedText
                        
                    }, withCancel: nil)
                    
                }, withCancel: nil)
                
            }
            
        }, withCancel: nil)
    }
    
    func setPostCount(){
    
        let ref = Database.database().reference().child("painting")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(self.userId!){
                let newRef = Database.database().reference().child("painting").child(self.userId!)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    //print("snapshot.childrenCount : \(snapshot.childrenCount)")
                    
                    self.postCount = Int(snapshot.childrenCount)
                    let attributedText = NSMutableAttributedString(string: "\(self.postCount)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
                    
                    attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
                    
                    self.noOfPosts.attributedText = attributedText
                    
                }, withCancel: nil)
                
            }
            
        }, withCancel: nil)
        
    }
    
    
    
    lazy var profileImage: CustomImageView = {
        
        let profileImageView = CustomImageView()
        //profileImageView.backgroundColor = .red
        return profileImageView
    }()
    
    
    lazy var userNameLabel: UILabel = {
        
        let userName = UILabel()
        userName.backgroundColor = .clear
        userName.text = "UserName"
        //userName.textColor = .white
        userName.font = UIFont.boldSystemFont(ofSize: 15)
        return userName
    }()
    
    lazy var noOfPosts: UILabel = {
        
        let posts = UILabel()
        //posts.textColor = .white
        let attributedText = NSMutableAttributedString(string: "\(0)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])

        attributedText.append(NSAttributedString(string: "posts", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))

        posts.attributedText = attributedText
        
        //posts.text = "1 \n posts"
        posts.textAlignment = .center
        posts.numberOfLines = 0
        return posts
    }()
    
    lazy var followers: UILabel = {
        
        let followers = UILabel()
        //followers.textColor = .white
        let attributedText = NSMutableAttributedString(string: "\(0)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])

        attributedText.append(NSAttributedString(string: "followers", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))

        followers.attributedText = attributedText
        //followers.text = "1 \n followers"
        followers.textAlignment = .center
        followers.numberOfLines = 0
        return followers
    }()
    
    lazy var following: UILabel = {
        
        let following = UILabel()
        //followers.textColor = .white
        let attributedText = NSMutableAttributedString(string: "\(0)\n", attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 16)])
        
        attributedText.append(NSAttributedString(string: "following", attributes: [NSAttributedStringKey.foregroundColor: UIColor.black,NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 16)]))
        
        following.attributedText = attributedText
        //followers.text = "1 \n followers"
        following.textAlignment = .center
        following.numberOfLines = 0
        return following
    }()
    
    lazy var editFollowButton: UIButton = {
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Follow", for: .normal)
        editButton.setTitleColor(.black, for: .normal)
        //editButton.tintColor = .white
        editButton.backgroundColor = #colorLiteral(red: 0.9171196157, green: 0.9768045545, blue: 0.9386992213, alpha: 1)
        editButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        editButton.layer.borderColor = UIColor.lightGray.cgColor
        editButton.layer.borderWidth = 1
        editButton.layer.cornerRadius = 3
        
        editButton.addTarget(self, action: #selector(handleEditFollow), for: .touchUpInside)
        
        return editButton
    }()
    
    @objc func handleEditFollow(){
        
        guard  let currentUserID = Auth.auth().currentUser?.uid else { return }
        guard let userId = user?.uid else {return}
        
        if editFollowButton.titleLabel?.text == "Edit User Profile"{
            
//            delegate?.didEdit()
//            print("editing")
//            return
            //editFollowButton.isHidden = true
            
        }
        
        if editFollowButton.titleLabel?.text == "UnFollow"{
            
            Database.database().reference().child("following").child(currentUserID).child(userId).removeValue { (error, reference) in
                
                if let error = error{
                    print("Can't unfollow user", error)
                }
                print("Successfully unfollowed user")
                self.setFollowStyle()
            }
            
            Database.database().reference().child("followers").child(userId).child(currentUserID).removeValue { (error, reference) in
                
                if let error = error{
                    print("Can't unfollow user", error)
                }
                print("Successfully unfollowed user")
                self.setFollowStyle()
            }
            
            self.setFollowers()
            self.setFollowing()
            
        }
            
        else {
            
            let ref = Database.database().reference().child("following").child(currentUserID)
            let values = [userId: 1]
            
            ref.updateChildValues(values) { (error, reference) in
                if let error = error{
                    print("Failed to follow user", error)
                }
                
            let ref1 = Database.database().reference().child("followers").child(userId)
            let values1 = [currentUserID:1]
                
            ref1.updateChildValues(values1, withCompletionBlock: { (error1, reference1) in
                if let error1 = error1{
                    
                    print("Follower fault", error1)
                }
            })
               
                
                self.setFollowing()
                self.setFollowers()
                print("Successfully folowed user", self.user?.username ?? "")
                self.editFollowButton.backgroundColor = #colorLiteral(red: 0.9171196157, green: 0.9768045545, blue: 0.9386992213, alpha: 1)
                self.editFollowButton.setTitle("UnFollow", for: .normal)
                self.editFollowButton.setTitleColor(.black, for: .normal)
                self.editFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
                
            }
        }
        
    }
    
    fileprivate func setFollowStyle(){
        
        self.editFollowButton.setTitle("Follow", for: .normal)
        self.editFollowButton.backgroundColor =  #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        self.editFollowButton.setTitleColor(.white, for: .normal)
        self.editFollowButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
    }
    
    fileprivate func  setEditFollowButton(){
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else {return}
        
        if currentUserId == userId{
            
            //perform edit profile
//            print("edit user details")
//            delegate?.didEdit()
//            return
            editFollowButton.isHidden = true
        }
            
        else{
            
             editFollowButton.isHidden = false
            
            Database.database().reference().child("following").child(currentUserId).child(userId).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let isFollowing = snapshot.value as? Int, isFollowing == 1{
                    
                    self.editFollowButton.setTitle("UnFollow", for: .normal)
                }
                else{
                    
                    self.setFollowStyle()
                }
                
            }) { (error) in
                print("Failed to check if following user or not", error)
            }
            
        }
    }
    
    
    fileprivate func setUpStackView(){
        
        let stackView = UIStackView(arrangedSubviews: [noOfPosts,followers,following])
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        
        containerView.addSubview(stackView)
        stackView.anchor(top: containerView.topAnchor, left: profileImage.rightAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 12, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 50)
//        stackView.anchor(top: topAnchor, left: profileImage.rightAnchor, bottom: nil, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 0, height: 50)
    
    }
    
    lazy var containerView: UIView = {
       
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
        
    }()
    
    
    func setupViews(){
        
        addSubview(containerView)
        containerView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
        containerView.addSubview(profileImage)
        containerView.addSubview(userNameLabel)
        containerView.addSubview(editFollowButton)
        
        profileImage.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 12, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 60, height: 60)
        
        profileImage.layer.cornerRadius = 60/2
        profileImage.clipsToBounds = true
        
         userNameLabel.anchor(top: profileImage.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 15, paddingBottom: 0, paddingRight: 0, width: 120, height: 30)
        
        setUpStackView()
        
        editFollowButton.anchor(top: noOfPosts.bottomAnchor, left: noOfPosts.rightAnchor, bottom: nil, right: following.leftAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 5, paddingRight: 0, width: 0, height: 30)
        
        
    }
    
    
    
}


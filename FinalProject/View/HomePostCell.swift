//
//  HomePostCell.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol HomePostCellDelegate {
    
    func didTapReview(post: Painting)
    func didLike(for cell: HomePostCell)
    func didUnLike(for cell: HomePostCell)
}


class HomePostCell: UICollectionViewCell {
    
    var likeCount: Int = 0
    
    var delegate: HomePostCellDelegate?
    
    var post: Painting? {
        didSet{
            
            guard let paintingUrl = post?.paintingUrl else { return }
            paintingImage.loadImage(urlString: paintingUrl)
            
            userName.text = post?.user.username
            
            guard let userProfileUrl = post?.user.profileImageURL else { return }
            userImage.loadImage(urlString: userProfileUrl)
            
            //likeButton.setImage(post?.hasLiked == true ? #imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal) : #imageLiteral(resourceName: "like_unselected").withRenderingMode(.alwaysOriginal) , for: .normal)
            setPaintingName()
            //setLikeStyle()
            setLikeCount()
            setLikeButton()
        }
    }
    
    func setLikeButton(){
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        guard let post = post else { return }
        guard let postId = post.id else { return }
        
        
        let ref = Database.database().reference().child("likes").child(postId)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(currentUserId){
                
                let newRef = Database.database().reference().child("likes").child(postId).child(currentUserId)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    if let value = snapshot.value as? Int, value == 1{
                       
                        //self.likedButton.setTitle("UnLine", for: .normal)
                        self.setUnLikeStyle()
                    }
                    else{
                        //self.likedButton.setTitle("Like", for: .normal)
                        self.setLikeStyle()
                        
                    }
                }, withCancel: nil)
                
                /*
                ref.child(currentUserId ).observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    if let value = snapshot.value as? Int, value == 1{
                       likedButton.setTitle("Like", for: .normal)
                        
                    } else{
                        
                        likedButton.setTitle("UnLike", for: .normal)
                        */
                        
            }
            
        }, withCancel: nil)
       
    }
    
    
    fileprivate func setPaintingName(){
        
        guard let post = post else { return }
        
        let attributedText = NSMutableAttributedString(string: post.user.username, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "  \(post.paintingTitle)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: "\n\n  ", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 4)]))
        let timeDisplay = post.creationDate.timeAgoDisplay()
        attributedText.append(NSAttributedString(string: timeDisplay, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: UIColor.lightGray]))
        paintingTitle.attributedText = attributedText
    }
    
    func setLikeCount(){
        
        guard  let postId = post?.id else { return }
        //guard let userId = post?.user.uid else {return}
        print("postId",postId)
        let ref = Database.database().reference().child("likes")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(postId){
                let newRef = Database.database().reference().child("likes").child(postId)
                
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                    let likeCount = Int(snapshot.childrenCount)
                    print("snapshot.childrenCount: ",snapshot.childrenCount)
                    let attributedText = NSMutableAttributedString(string: "Likes:  \(likeCount)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])

                    
                    self.likeLabel.attributedText = attributedText
                    
                }, withCancel: nil)
                
                newRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                    
                    let likeCount = Int(snapshot.childrenCount)
                    print("snapshot.childrenCount: ",snapshot.childrenCount)
                
                    let attributedText = NSMutableAttributedString(string: "Likes:  \(likeCount)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
                    
                    
                    self.likeLabel.attributedText = attributedText
                    
                }, withCancel: nil)
                
                
            }
            
        }, withCancel: nil)
    }
    
    let userImage: CustomImageView = {
        
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let paintingImage: CustomImageView = {
        
        let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let userName: UILabel = {
    
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "User Name"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let infoButton: UIButton = {
       
        let button = UIButton(type: .infoDark)
        button.translatesAutoresizingMaskIntoConstraints = false
        //button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    let paintingTitle: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.attributedText = attributedText
        //label.text = "PaintingTitle"
        
        
        label.numberOfLines = 0
        
        return label
        
    }()
    

    
    lazy var likeLabel: UILabel = {
        
        let label = UILabel()
        
        label.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        
        //label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        let attributedText = NSMutableAttributedString(string: "Likes:  \(0)", attributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        label.attributedText = attributedText
        
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 4
        label.font = UIFont(name: "HoeflerText-BlackItalic", size: 16)
        label.font = UIFont.boldSystemFont(ofSize: 16)
        //label.text = "PaintingTitle"
        label.numberOfLines = 0
        
        return label
    }()

    
    lazy var commentButton: UIButton = {

        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor =  #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        //button.font = UIFont(name: "HoeflerText-BlackItalic", size: 16)
        //button.setImage(#imageLiteral(resourceName: "comment").withRenderingMode(.alwaysOriginal), for: .normal)
        button.setImage(#imageLiteral(resourceName: "comment"), for: .normal)
        //button.setImage(#imageLiteral(resourceName: "like_selected").withRenderingMode(.alwaysOriginal), for: .selected)
        button.imageEdgeInsets = UIEdgeInsets(top: 6,left: -20,bottom: 6,right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
         button.tintColor = .white
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Review", for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        button.layer.borderColor = UIColor.lightGray.cgColor

        button.addTarget(self, action: #selector(handleReviews), for: .touchUpInside)
        //button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    @objc func handleReviews(){
        
        print("Handle Reviews")
        //delegate?.didTapReview()
        
        guard let post = post else { return }
        
        delegate?.didTapReview(post: post)
        
        
    }
    
    lazy var likedButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        button.backgroundColor =  #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        button.setImage(UIImage(named:"like_selected"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 6,left: -30,bottom: 6,right: 0)
        button.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        
        
        button.setTitle("Like", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 4
        
        button.addTarget(self, action: #selector(handleLikeDisLike), for: .touchUpInside)
        
        return button
    }()
    
    @objc func handleLikeDisLike(){
        
        //guard  let postId = post?.id else { return }
        //guard let userId = post?.user.uid else {return}
        
        if likedButton.titleLabel?.text == "UnLike"{
            
                delegate?.didUnLike(for: self)
                self.setLikeStyle()
            
        }
            
        else {
            

            delegate?.didLike(for: self)
            self.likedButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 1, blue: 0.9882352941, alpha: 1)
            //self.likedButton.setImage(UIImage(named: "like_selected"), for: .selected)
           
            //self.likedButton.imageEdgeInsets = UIEdgeInsets(top: 6,left: -30,bottom: 6,right: 0)
            //self.likedButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
            self.likedButton.setTitleColor(.black, for: .normal)
            self.likedButton.setTitle("UnLike", for: .normal)
            self.likedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
            self.likedButton.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
            self.likedButton.layer.borderWidth = 1
            self.likedButton.layer.cornerRadius = 4
           
            
        }
    }
    
    fileprivate func setLikeStyle(){
        
        self.likedButton.backgroundColor =  #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        
        self.likedButton.setImage(UIImage(named:"like_selected"), for: .normal)
        self.likedButton.imageEdgeInsets = UIEdgeInsets(top: 6,left: -30,bottom: 6,right: 0)
        self.likedButton.titleEdgeInsets = UIEdgeInsets(top: 0,left: 0,bottom: 0,right: 0)
        
        self.likedButton.setTitleColor(.white, for: .normal)
        self.likedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.likedButton.layer.borderColor = UIColor(white: 0, alpha: 0.2).cgColor
        self.likedButton.setTitle("Like", for: .normal)
        self.likedButton.layer.borderWidth = 1
        self.likedButton.layer.cornerRadius = 4

    }
    
    fileprivate func setUnLikeStyle(){
        
        self.likedButton.backgroundColor = #colorLiteral(red: 0.9764705882, green: 1, blue: 0.9882352941, alpha: 1)
        self.likedButton.setTitleColor(.black, for: .normal)
        self.likedButton.setTitle("UnLike", for: .normal)
        self.likedButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.likedButton.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        self.likedButton.layer.borderWidth = 1
        self.likedButton.layer.cornerRadius = 4
        
    }
  
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //backgroundColor = .blue
        
        addSubview(paintingImage)
        addSubview(userImage)
        addSubview(userName)
        //addSubview(infoButton)
       // addSubview(optionsButton)
        addSubview(paintingTitle)
        
        //Profile Image View
        userImage.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        userImage.layer.cornerRadius = 20
        
        //User Name Label
        userName.anchor(top: topAnchor, left: userImage.rightAnchor, bottom: paintingImage.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        // userName.anchor(top: topAnchor, left: userImage.rightAnchor, bottom: paintingImage.topAnchor, right: optionsButton.leftAnchor, paddingTop: 0, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //info Button
//        infoButton.anchor(top: topAnchor, left: nil, bottom: paintingImage.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
//
        //optionsButton
        //optionsButton.anchor(top: topAnchor, left: nil, bottom: paintingImage.topAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 50, height: 0)
        
        //Painting Image
        paintingImage.anchor(top: userImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        paintingImage.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setUpButtons()
        
        paintingTitle.anchor(top: likedButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        
    }
    
    fileprivate func setUpButtons(){
        
        let stackView = UIStackView(arrangedSubviews: [likedButton,likeLabel,commentButton])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
       
        
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.axis = .horizontal
        
         addSubview(stackView)
        
        
        stackView.anchor(top: paintingImage.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, paddingTop: 8, paddingLeft: 12, paddingBottom: 0, paddingRight: 12, width: 120, height: 40)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



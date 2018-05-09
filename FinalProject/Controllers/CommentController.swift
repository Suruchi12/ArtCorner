//
//  CommentController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class CommentController: UICollectionViewController, UICollectionViewDelegateFlowLayout, ReviewInputViewDelegate {

    var post: Painting?
    var reviewId = "reviewId"
    
    lazy var bgImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Reviews"
        collectionView?.backgroundColor = .white
        
//        bgImage.image = UIImage(named: "chatBackground")
//        bgImage.contentMode = .scaleAspectFill
//        collectionView?.backgroundView = bgImage
        
        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -60, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .interactive
        
        collectionView?.register(ReviewCell.self, forCellWithReuseIdentifier: reviewId)
        didMoveToWindow()
        fetchReviews()
        
        
    }
    
    
    var reviewsArray = [Review]()
    
    //fetch all reviews from Firebase
    fileprivate func fetchReviews(){
        
        guard let postId = self.post?.id else { return }
        
        let ref = Database.database().reference().child("reviews").child(postId)
        ref.observe(.childAdded, with: { (snapshot) in
            
            guard let dictionary = snapshot.value as? [String: Any] else { return}
            
            guard let uid = dictionary["userId"] as? String else { return}
            
            Database.fetchUserUID(uid: uid, completion: { (user) in
                
                let review = Review(user: user, dictionary: dictionary)
                //review.user = user
                print(review.text as Any, review.uid as Any)
                self.reviewsArray.append(review)
                self.collectionView?.reloadData()
                
            })
            
            
        }) { (error) in
            
            print("Failed to observe reviews", error)
        }
    }
    
    //return the number of cells/reviews in the controller
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return reviewsArray.count
    }
    
    //Custom size of each review cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = ReviewCell(frame: frame)
        dummyCell.review = reviewsArray[indexPath.item]
        dummyCell.layoutIfNeeded()
        let targetSize = CGSize(width: view.frame.width, height: 100)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }
    
    //Customize the cell
    //give the array to each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewId, for: indexPath) as! ReviewCell
        cell.review = self.reviewsArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 0
    }    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        didMoveToWindow()
        tabBarController?.tabBar.isHidden =  true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
     func didMoveToWindow() {
        //super.didMoveToWindow()
        if #available(iOS 11.0, *) {
            if let window = self.collectionView?.window {
                self.view.bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
            }
        }
    }
    
  
    
    //customized accessory view to adjust for iPhoneX
    lazy var containerView: ReviewInputAccessoryView = {
    
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        let reviewView = ReviewInputAccessoryView(frame: frame)
        reviewView.delegate = self

        return reviewView
        
//        let containerView = UIView()
//
//        containerView.backgroundColor = .white
//
//        containerView.frame = CGRect(x: 0, y: 0, width: 100, height: 60) //CGRect(x: 0, y: 0, width: 100, height: 50)
//        //CGRect(x: 0, y: 0, width: ScreenSize.width, height: DeviceType.isiPhoneX ? 50 + 44 : 50)
//
//        return containerView

    }()
    
    //Send review to Firebase
    func didSendReview(for review: String){
        
        print("insert review into firebase")
        
        print("Send a Review!", review)
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let postId = self.post?.id ?? ""
        let values = ["text": review, "creationDate": Date().timeIntervalSince1970, "userId": uid] as [String : Any]
        
        Database.database().reference().child("reviews").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
            if let error = error{
                print("Failure to update Firebase",error)
                return
                
            }
            print("Succesfully sent child ids to firebase")
            self.containerView.clearReviewTextField()
        }
    }
    
//
//    @objc func handleSendReview(){
//
//        print("post id", self.post?.id ?? "")
//        print("Send a Review!", reviewTextField.text ?? "")
//
//        guard let uid = Auth.auth().currentUser?.uid else {return}
//
//        let postId = self.post?.id ?? ""
//        let values = ["text": reviewTextField.text ?? "", "creationDate": Date().timeIntervalSince1970, "userId": uid] as [String : Any]
//
//        Database.database().reference().child("reviews").child(postId).childByAutoId().updateChildValues(values) { (error, reference) in
//
//            if let error = error{
//                print("Failure to update Firebase",error)
//                return
//            }
//
//            print("Succesfully sent child ids to firebase")
//
//        }
//
//    }
    
    override var inputAccessoryView: UIView?{
        
        get{
//            view.addSubview(containerView)
//            containerView.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
            return containerView
            
        }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
}

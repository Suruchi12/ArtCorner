//
//  HomeController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase



class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    let cellId = "cellId"
    var posts = [Painting]()
    let refreshControl = UIRefreshControl()
    let name = NSNotification.Name(rawValue: "UpdateHome")

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0

        NotificationCenter.default.addObserver(self, selector: #selector(handleNewPost), name: name, object: nil)
        
        collectionView?.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.03928178399, green: 0.9340101523, blue: 0.5519225757, alpha: 1)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: cellId)
        
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        setUpNavigationItems()
        
        fetchAllPosts()
      
    }
   
    @objc func handleNewPost(){
        
        handleRefresh()
    }
    
    @objc func handleRefresh(){
        
        posts.removeAll()
        fetchAllPosts()
    }
    
    fileprivate func fetchAllPosts(){
        
        fetchPaintings()
        fetchFollowingUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        //handleRefresh()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false
        self.tabBarController?.tabBar.layer.zPosition = 0
        handleRefresh()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.layer.zPosition = -1
        handleRefresh()
    }
    

    @objc func handleWiki(){
        
        print("wiki")
        let commentController = WikiController()
        self.tabBarController?.tabBar.isHidden = true
        hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.layer.zPosition = -1
        navigationController?.pushViewController(commentController, animated: true)
        tabBarController?.tabBar.isHidden = false
        hidesBottomBarWhenPushed = false
    }
    
    
    fileprivate func fetchFollowingUsers(){
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }

        Database.database().reference().child("following").child(currentUserId).observeSingleEvent(of: .value, with: { (snapshot) in

            guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}

            userIdsDictionary.forEach({ (key,value) in

                Database.fetchUserUID(uid: key, completion: { (user) in

                    self.fetchPostWithUser(user: user)
                })
            })

        }) { (error) in

            print("Cant fetch",error)
        }

    }

  
    /*
    fileprivate func fetchFollowingUsers(){
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        let ref =  Database.database().reference().child("following")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.hasChild(currentUserId){
                
                let newRef = Database.database().reference().child("following").child(currentUserId)
                newRef.observeSingleEvent(of: .value, with: { (snapshot) in
                
                    guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
                    userIdsDictionary.forEach({ (key,value) in
                        
                        Database.fetchUserUID(uid: key, completion: { (user) in
                        
                            self.fetchPostWithUser(user: user)
                        })
                    })
                   
                    newRef.observeSingleEvent(of: .childRemoved, with: { (snapshot) in
                        
//                        guard let userIdsDictionary = snapshot.value as? [String: Any] else {return}
//                        userIdsDictionary.forEach({ (key,value) in
//
//                            Database.fetchUserUID(uid: key, completion: { (user) in
//
//                                self.fetchPostWithUser(user: user)
//                            })
//                        })
                        self.posts.removeAll()
                        //self.fetchAllPosts()
                        self.handleRefresh()
                        
                    }, withCancel: { (error2) in
                        print("error",error2)
                    })
                }, withCancel: { (error) in
                    print("error",error)
                })
                
            }
            
        }) { (error1) in
        
            print("failed",error1)
        }
        
    }
    
    */
    
    func setUpNavigationItems(){
    
        //navigationItem.titleView?.backgroundColor = #colorLiteral(red: 0.8262769713, green: 1, blue: 0.9802049735, alpha: 1)
        navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "art_corner_logo"))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "wikipedia").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleWiki))
       // navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "camera3").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleCamera))
        
    }
    
    
    
    fileprivate func fetchPaintings(){
     
        //print("fetching Paitings!")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        

        Database.fetchUserUID(uid: uid, completion: { (user) in
            
            //print("completion block")
            self.fetchPostWithUser(user: user)
        })
       
    }
    
    func fetchPostWithUser(user: User){
        
        let uid = user.uid
        
        let ref = Database.database().reference().child("painting").child(uid)
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            self.collectionView?.refreshControl?.endRefreshing()
            guard let dicionaries = snapshot.value as? [String: Any] else { return }
            dicionaries.forEach({ (key, value) in
                
                guard let dictionary = value as? [String: Any] else { return }
                //print(dictionary)
                var post = Painting(user: user, dictionary: dictionary)
                post.id = key
                
                guard let currentUserId = Auth.auth().currentUser?.uid else {return}
                
                let ref = Database.database().reference().child("likes").child(key)
                ref.child(currentUserId ).observeSingleEvent(of: .value, with: { (snapshot) in


                    if let value = snapshot.value as? Int, value == 1{
                        post.hasLiked = true
                       
                    } else{
                        
                        post.hasLiked = false
                      
                    }
                    
                    self.posts.append(post)

                    self.posts.sort(by: { (post1, post2) -> Bool in

                        return post1.creationDate.compare(post2.creationDate) == .orderedDescending
                    })

                    self.collectionView?.reloadData()

                }, withCancel: { (error) in

                    print("failed to fetch liked post for user", error)
                })

                
                //print("post",post)
            })

        }) { (error) in

            print("Failed to fetch paintings!",error)
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return posts.count
    }
    
    override func viewDidLayoutSubviews() {

        collectionView?.frame = self.view.frame

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 40 + 8 + 8 //user name, profile image
        height += view.frame.width
        height += 50
        height += 60
    
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! HomePostCell
        
        if indexPath.count > 0{
        
            cell.post = posts[indexPath.item]
        }
        else{
            
            print("No posts to fetch")
            
        }
        cell.delegate = self
        return cell
    }
    
    func didTapReview(post: Painting) {
        
        print("Message from home controller")
        //print(post.paintingTitle)
        hidesBottomBarWhenPushed = true
        let commentController = CommentController(collectionViewLayout: UICollectionViewFlowLayout())
        commentController.post = post
        navigationController?.pushViewController(commentController, animated: true)
        hidesBottomBarWhenPushed = false
    }
    
    func didLike(for cell: HomePostCell){
        
        print("Home controller did like")
        guard let indexPath  = collectionView?.indexPath(for: cell) else {return}
        
        var post = self.posts[indexPath.item]
        
        guard let postId = post.id else {return}
        //let userId = post.user.uid
        
        guard let uid = Auth.auth().currentUser?.uid else {  return }
        let values = [uid: post.hasLiked == true ? 0 : 1]
        Database.database().reference().child("likes").child(postId).updateChildValues(values) { (error, _) in

            if let error = error{

                print("Couldnt save Likes into Db", error )
                return
            }
            print("Successfully liked post")
            post.hasLiked = !post.hasLiked
            self.posts[indexPath.item] = post
            //self.collectionView?.reloadItems(at: [indexPath])
            cell.setLikeCount()
        }
    }
    
    func didUnLike(for cell: HomePostCell){
        
        print("Home controller did Un like")
        guard let indexPath  = collectionView?.indexPath(for: cell) else {return}

        let post = self.posts[indexPath.item]

        guard let postId = post.id else {return}

         guard let uid = Auth.auth().currentUser?.uid else {  return }

        Database.database().reference().child("likes").child(postId).child(uid).removeValue() { (error1, ref) in
            if error1 != nil{
                print("Failed to delete movie", error1!)
                return

            }
            print("Successfully Un liked post")

            cell.setLikeCount()
        }
    }
}


//post.hasLiked = !post.hasLiked
//self.posts[indexPath.item] = post
//self.collectionView?.reloadItems(at: [indexPath])

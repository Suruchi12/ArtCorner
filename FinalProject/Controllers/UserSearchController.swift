//
//  UserSearchController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/28/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    let cellId = "cellId"
    var users = [User]()
    var filteredUsers = [User]()
    
    lazy var searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter User Name"
        searchBar.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.8871425511, green: 0.8871425511, blue: 0.8871425511, alpha: 1)
        searchBar.delegate = self
        searchBar.isHidden = false
        return searchBar
    }()
    
    @objc func handleRefresh(){
        
        users.removeAll()
        filteredUsers.removeAll()
        fetchAllUsers()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        handleRefresh()
        searchBar.setShowsCancelButton(false, animated: true)
        // Remove focus from the search bar.
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            filteredUsers = users
            //handleRefresh()
        }
        else{
            filteredUsers = self.users.filter({ (users) -> Bool in
                
                return users.username.lowercased().contains(searchText.lowercased())
            })
        }
        
        filteredUsers = self.users.filter { (user) -> Bool in
            
            return user.username.contains(searchText)
        }
        
        self.collectionView?.reloadData()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(true)
        searchBar.isHidden = false
        
    }
    
    lazy var bgImage = UIImageView()

    override func viewDidLoad() {
        super.viewDidLoad()

        //collectionView?.backgroundColor = hexStringToUIColor(hex: "#E6E6FA")
        searchBar.isHidden = false
        
        
//        backgroundImage.image = UIImage(named: "Blue-Black-White")
//        //self.collectionView.insertSubview(backgroundImage, at: 0)
//        collectionView?.addSubview(backgroundImage)
        
        collectionView?.backgroundColor = .clear
        //collectionView?.backgroundColor = UIColor(patternImage: UIImage(named: "Blue-Black-White")!)
        
        bgImage.image = UIImage(named: "aquablue")
        bgImage.contentMode = .scaleAspectFill
        collectionView?.backgroundView = bgImage
        
        
        //Refresh Animation
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
        
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        //navigationController?.navigationBar.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        navigationController?.navigationBar.addSubview(searchBar)
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.03928178399, green: 0.9340101523, blue: 0.5519225757, alpha: 1)

        let navBar = navigationController?.navigationBar
        searchBar.anchor(top: navBar?.safeAreaLayoutGuide.topAnchor, left: navBar?.safeAreaLayoutGuide.leftAnchor, bottom: navBar?.bottomAnchor, right: navBar?.safeAreaLayoutGuide.rightAnchor, paddingTop: 5, paddingLeft: 8, paddingBottom: 0, paddingRight: 8, width: 0, height: 0)
        
        collectionView?.register(SearchCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        fetchAllUsers()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {

        navigationController?.navigationBar.prefersLargeTitles = true
        searchBar.isHidden = false
        
    }
    
    

    fileprivate func fetchAllUsers(){
    
        let ref = Database.database().reference().child("users")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            
            guard let dictionaries = snapshot.value as? [String: Any] else {return}
            
            dictionaries.forEach({ (key, value) in
                
                if key ==  Auth.auth().currentUser?.uid{
                    
                    return
                }
                
                guard let userDictionary = value as? [String: Any]  else {return}
                
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
            
            self.users.sort(by: { (user1, user2) -> Bool in
                
                return user1.username.compare(user2.username) == .orderedAscending
            })
            
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
            
        }) { (error) in
            
            print("Failed to fetch users",error)
        }
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 66)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        searchBar.isHidden = true
        searchBar.resignFirstResponder()
        navigationController?.navigationBar.prefersLargeTitles = false
        let user = filteredUsers[indexPath.item]
        //let userProfileController = UserProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        let userProfileController = UserProfileController()
        userProfileController.userId = user.uid
        userProfileController.navigationItem.rightBarButtonItem?.isEnabled = false
        navigationController?.pushViewController(userProfileController, animated: true)
        //navigationController?.navigationBar.prefersLargeTitles = true
        
    }
    
}

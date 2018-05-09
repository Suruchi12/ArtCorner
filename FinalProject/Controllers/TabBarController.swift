//
//  TabBarController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/25/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        let index = viewControllers?.index(of: viewController)
        //print(index as Any)
        
        if index == 1{
            
            let layout = UICollectionViewFlowLayout()
            let selectPhoto = PhotoSelectorController(collectionViewLayout: layout)
            let navController = UINavigationController(rootViewController: selectPhoto)

            present(navController, animated: true, completion: nil)
            
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //view.backgroundColor = .red
        self.delegate = self
        tabBarController?.tabBar.layer.zPosition = 0

        tabBar.isTranslucent = false
        //tabBar.backgroundColor =  #colorLiteral(red: 0, green: 0.5690457821, blue: 0.5746168494, alpha: 1)
        tabBar.barTintColor =  hexStringToUIColor(hex: "#D0FAEE")
        
        if Auth.auth().currentUser == nil{
            
            DispatchQueue.main.async {
                
               // let loginGuideController = LoginGuideViewController()
               // self.present(loginGuideController, animated: true, completion: nil)
                
                //helps push sign up controller
                let loginController = LoginGuideViewController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.isNavigationBarHidden = true
                self.present(navController, animated: true, completion: nil)
                
            }
            
           return
        }
        
        setUpViewControllers()
      
        
    }
    
    
    func setUpViewControllers(){
    
        //Home Feed
        let homeController = templateNavController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), selectedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()))
      
        //Search
        
        let searchNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), selectedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: UserSearchController(collectionViewLayout: UICollectionViewFlowLayout()))
        
        
        //Add
        let addPostController = templateNavController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), selectedImage: #imageLiteral(resourceName: "plus_unselected"))

        let userProfileNavController = templateNavController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), selectedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: UserProfileController())
        tabBar.tintColor = .black
        
        viewControllers = [homeController,addPostController,searchNavController,userProfileNavController]
        
        guard let items = tabBar.items else {return}
        for item in items{
            
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
    }
    
    fileprivate func templateNavController(unselectedImage: UIImage, selectedImage: UIImage, rootViewController: UIViewController = UIViewController())-> UINavigationController{
        
        let viewController = rootViewController
        let navController = UINavigationController(rootViewController: viewController)
        
        navController.tabBarItem.image =  unselectedImage
        navController.tabBarItem.selectedImage =  selectedImage
        return navController
    }
}

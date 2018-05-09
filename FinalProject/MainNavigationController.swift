//
//  MainNavigationController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 5/1/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //view.backgroundColor = .red
        
        
        if isLoggedIn() {
            
           // let homeController = TabBarController()
            //viewControllers = [homeController]
            guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
            mainTabBarController.setUpViewControllers()
            present(mainTabBarController, animated: true, completion: nil)
        }
        else{
            
            //perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
            let loginController = LoginGuideViewController()
            present(loginController, animated: true, completion: nil)
            
        }
    }
    
    fileprivate func isLoggedIn() -> Bool{
        
        if Auth.auth().currentUser == nil{
            
            return false
        }
        else{
        
            return true
        }
    }
    
    @objc func showLoginController(){
        
        let loginController = LoginGuideViewController()
        present(loginController, animated: true, completion: nil)
    }
}


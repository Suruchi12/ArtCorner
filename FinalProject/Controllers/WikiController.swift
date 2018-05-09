//
//  WikiController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 5/2/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON
import SDWebImage

class WikiController: UIViewController, UISearchBarDelegate {
    
    let wikipediaURL = "https://en.wikipedia.org/w/api.php"

    let containerView: UIView = {
       
        let containerView = UIView()
        //containerView.backgroundColor = .yellow
        containerView.backgroundColor = UIColor(patternImage: UIImage(named: "wikiBackground")!)

        return containerView
    }()
    
    lazy var imageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Wikipedia(inverse)")
        //imageView.backgroundColor = #colorLiteral(red: 0.4701334635, green: 0.688937717, blue: 0.8092176649, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    lazy var textView: UITextView = {
        
        let textView = UITextView()
        //textView.text = "Wikipedia Information"
        //textView.backgroundColor = #colorLiteral(red: 0.4701334635, green: 0.688937717, blue: 0.8092176649, alpha: 1)
        textView.backgroundColor = .clear
        //textField.font = UIFont.systemFont(ofSize: 14)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textAlignment = .justified
        textView.textColor = #colorLiteral(red: 0.05113129139, green: 0.2124793829, blue: 0.3647023833, alpha: 1)
        textView.sizeToFit()
        textView.font = UIFont(name: "HoeflerText-BlackItalic", size: 14)
        textView.isEditable = false
        return textView
    }()
    
    lazy var searchBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter Text"
        searchBar.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9559084141, green: 0.9559084141, blue: 0.9559084141, alpha: 1)
        searchBar.delegate = self
        
        return searchBar
    }()
    
    func setWiki(){
        
        imageView.image = UIImage(named: "Wikipedia(inverse)")
        textView.text = " "
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        
        textView.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{
            
           setWiki()
        }
        
        else{
        
            let pName = searchText
            requestInfo(pName: pName)
        }
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchBar.text = ""
        setWiki()
        searchBar.setShowsCancelButton(false, animated: true)
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        textView.resignFirstResponder()
    }
    
    func requestInfo(pName: String){
        
        let parameters : [String:String] = [
            
            "format" : "json",
            "action" : "query",
            "prop"   : "extracts|pageimages",
            "exintro": "",
            "explaintext" : "",
            "titles" : pName,
            //"titles" : "Mona Lisa",
            "indexpageids" : "",
            "redirects" : "1",
            "pithumbsize" : "400"
        ]
        Alamofire.request(wikipediaURL, method: .get, parameters: parameters).responseJSON { (response) in
            if response.result.isSuccess{
                print("Got the Wikipedia")
                print(response)
                
                let infoJSON: JSON = JSON(response.result.value!)
                let pageID = infoJSON["query"]["pageids"][0].stringValue
                let artDescription = infoJSON["query"]["pages"][pageID]["extract"].stringValue
                
                let artImageURL = infoJSON["query"]["pages"][pageID]["thumbnail"]["source"].stringValue
                self.imageView.sd_setImage(with: URL(string: artImageURL))
                //self.paintingImage.sd_setImage(with: URL(string: artImageURL))
                //print(artDescription)
                self.textView.text = artDescription
        
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tabBarController?.tabBar.layer.zPosition = -1

    }
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.layer.zPosition = -1

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.7724274754, green: 0.8815478289, blue: 0.9635244542, alpha: 1)
        
        
        tabBarController?.tabBar.layer.zPosition = -1
        //tabBarController?.tabBar.isHidden = true
        //tabBarController?.tabBar.barTintColor = #colorLiteral(red: 0.7724274754, green: 0.8815478289, blue: 0.9635244542, alpha: 1)
        
        setWiki()
       
        view.addSubview(containerView)
        containerView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        containerView.addSubview(searchBar)
        containerView.addSubview(imageView)
        containerView.addSubview(textView)
        
        searchBar.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        imageView.anchor(top: searchBar.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.42).isActive = true
        
        textView.anchor(top: imageView.bottomAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        
        
    }
}

//
//  SharePhotoController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/27/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage?{
        didSet{
            self.imageView.image = selectedImage
        }
    }
    
    var paintingName: String?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //view.backgroundColor = #colorLiteral(red: 0.8262769713, green: 1, blue: 0.9802049735, alpha: 1)
       
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "shareBackground")
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(handlePost))
        
        setUpSubViews()
        
    }
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    
    @objc func handlePost(){
        
        print("handle sharing of posts")

        guard let paintingTitle = textView.text, paintingTitle.count > 0 else {return}
        guard  let image = selectedImage else { return }
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else {return}
        
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        let paintingName = NSUUID().uuidString
        Storage.storage().reference().child("paintings").child(paintingName).putData(uploadData, metadata: nil) { (metadata, error) in
            
            if let error = error{
                
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Failed to upload Painting Image",error)
                return
            }

            Storage.storage().reference().child("paintings").child(paintingName).downloadURL(completion: { (url, error) in
                if error != nil {
                    print(error as Any)
                } else {
                    guard let imageUrl = url?.absoluteString else { return }
                    self.paintingName = imageUrl
                    print("Successful saving profile image to Firebase: - ", self.paintingName!)
                    
                    self.savePaintingToFirebase(imageUrl: imageUrl)
                }
            })
        }
    }
    
    fileprivate func savePaintingToFirebase(imageUrl: String){
        
        print("savePaintingToFirebase")
        print(imageUrl)
        guard let postPaiting = selectedImage else { return }
        guard let paintingTitle = textView.text else { return }
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let userPaintingPostRef = Database.database().reference().child("painting").child(uid)
       
        let ref = userPaintingPostRef.childByAutoId()
        
        let paintingDict = ["paintingUrl": imageUrl, "paintingTitle": paintingTitle, "imageWidth": postPaiting.size.width, "imageHeight": postPaiting.size.height, "creationDate": Date().timeIntervalSince1970] as [String : Any]

        ref.updateChildValues(paintingDict) { (error, reference) in
            
            if let error = error{
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                print("Couldn't save painting posts to Firebase",error)
            }
            print("Successfully saved painting post to Firebase")
            self.dismiss(animated: true, completion: nil)
            
            let name = NSNotification.Name(rawValue: "UpdateHome")
            
            NotificationCenter.default.post(name: name, object: nil)

        }
        
    }
    
    let containerView: UIView = {
    
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = .blue
        return containerView
    }()
    
    let imageView: UIImageView = {
    
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    let bottomContainer: UIView = {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = .red
        return containerView
        
    }()
    
    let textView: UITextField = {
       
        let textView = UITextField()
        textView.backgroundColor = .white
        textView.placeholder = "Enter Tile of Painting"
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let myColor : UIColor = UIColor.lightGray
        textView.layer.borderColor = myColor.cgColor
        
        textView.layer.borderWidth = 0.8
        //textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.font = UIFont(name: "ArialHebrew-Bold", size: 20)
        textView.textAlignment = .center
        
        return textView
        
    }()
    
    let divider: UIView = {
        
        let divider = UIView()
        divider.backgroundColor = UIColor.lightGray
        return divider
    }()
    
    fileprivate func setUpSubViews(){
        
        print("inside setup sub views")

        
        view.addSubview(containerView)
        view.addSubview(bottomContainer)
        
        
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.75).isActive = true

        containerView.addSubview(imageView)
        //containerView.addSubview(divider)
        
        imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 0.65).isActive = true
        imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.65).isActive = true

       // divider.anchor(top: nil, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        //Bottom Container
        bottomContainer.anchor(top: containerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        bottomContainer.addSubview(textView)
        
        //bottomContainer.addSubview(divider)
        
        textView.centerYAnchor.constraint(equalTo: bottomContainer.centerYAnchor).isActive = true
        textView.centerXAnchor.constraint(equalTo: bottomContainer.centerXAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: bottomContainer.heightAnchor, multiplier: 0.7).isActive = true
        textView.widthAnchor.constraint(equalTo: bottomContainer.widthAnchor, multiplier: 0.75).isActive = true
        
//        divider.anchor(top: nil, left: textView.leftAnchor, bottom: textView.topAnchor, right: textView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
//
    }
    
}

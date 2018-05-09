//
//  SignUpViewController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/25/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var profilePicUrl: String?

    lazy var addPhotoButton:UIButton = {
        
        let addPhotoButton = UIButton()
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        addPhotoButton.setImage(#imageLiteral(resourceName: "addProfileImage").withRenderingMode(.alwaysOriginal), for: .normal)
        addPhotoButton.addTarget(self, action: #selector(handleProfilePhoto), for: .touchUpInside)
        
        return addPhotoButton
        
    }()
    
    @objc func handleProfilePhoto(){
        
        print("Select Image!")
        //cellDelegate?.handleProfileImage(for: self)
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
        present(imagePicker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let modifiedImage = info["UIImagePickerControllerEditedImage"] as? UIImage?{
            
            addPhotoButton.setImage(modifiedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        else if let orImage = info["UIImagePickerControllerOriginalImage"] as? UIImage?{
            
            addPhotoButton.setImage(orImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        
        addPhotoButton.layer.cornerRadius = addPhotoButton.frame.width/2
        
        addPhotoButton.layer.masksToBounds = true
        addPhotoButton.layer.borderColor = UIColor.black.cgColor
        addPhotoButton.layer.borderWidth = 3
        dismiss(animated: true, completion: nil)
        
    }
    
    
    lazy var userNameTextField: UITextField = {
        
        let userName = UITextField()
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.backgroundColor = #colorLiteral(red: 0.911393027, green: 0.911393027, blue: 0.911393027, alpha: 1)
        userName.placeholder = "Enter User Name"
        userName.borderStyle = .roundedRect
        userName.font = UIFont.systemFont(ofSize: 15)
        userName.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return userName
    }()
    
    lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.backgroundColor = #colorLiteral(red: 0.911393027, green: 0.911393027, blue: 0.911393027, alpha: 1)
        emailTextField.placeholder = "Enter Email"
        emailTextField.keyboardType = .emailAddress
        emailTextField.borderStyle = .roundedRect
        emailTextField.font = UIFont.systemFont(ofSize: 15)
        
        emailTextField.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return emailTextField
    }()
    
    
    lazy var passwordTextField: UITextField = {
        let passwordtf = UITextField()
        passwordtf.translatesAutoresizingMaskIntoConstraints = false
        passwordtf.backgroundColor = #colorLiteral(red: 0.911393027, green: 0.911393027, blue: 0.911393027, alpha: 1)
        passwordtf.placeholder = "Enter Password"
        passwordtf.isSecureTextEntry = true
        passwordtf.borderStyle = .roundedRect
        passwordtf.font = UIFont.systemFont(ofSize: 15)
        passwordtf.addTarget(self, action: #selector(handleInputChange), for: .editingChanged)
        
        return passwordtf
    }()
    
    //Sign Up Button
    lazy var signUpButton:UIButton = {
        
        let signUpButton = UIButton(type: .system)
        
        //addPhotoButton.backgroundColor = .green
        
        //signUpButton.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.5205263084, blue: 0.5597232519, alpha: 1)
        signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.6077153192, blue: 0.4818769324, alpha: 1)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.setTitle("Sign Up", for: .normal)
        signUpButton.layer.cornerRadius = 5
        signUpButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //signUpButton.setTitleColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), for: .normal)
        signUpButton.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        signUpButton.isEnabled = false
        return signUpButton
        
    }()
    
    //Login Button
    lazy var LoginButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let myNormalAttributedTitle = NSMutableAttributedString(string: "Already have an account? ",
                                                                attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        myNormalAttributedTitle.append(NSAttributedString(string: "Sign In", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize:15),NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.3882391449, blue: 0.2153393709, alpha: 1)]))
        
        button.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        
        //button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(presentLogIn), for: .touchUpInside)
        return button
    }()

    @objc func presentLogIn(){
        
        print("Presenting Login VC")
        _ = navigationController?.popViewController(animated: true)
        //present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    @objc func handleInputChange(){
        
        let isInfoValid = emailTextField.text?.count ?? 0 > 0 && userNameTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isInfoValid {
            
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.3882391449, blue: 0.2153393709, alpha: 1)
            signUpButton.setTitleColor(.white, for: .normal)
        }
            
        else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = #colorLiteral(red: 1, green: 0.6077153192, blue: 0.4818769324, alpha: 1)
            signUpButton.setTitleColor(.white, for: .normal)
        }
        
    }
    

    
   
    
    @objc func handleRegistration(){
        
        guard let email = emailTextField.text, email.count > 0 else {return}
        guard let password = passwordTextField.text, password.count > 0 else {return}
        guard let userName = userNameTextField.text, userName.count > 0 else {return}
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error{
                print("Failed to create user", error)
                return
            }
            print("Successfully created user", user?.uid ?? "")
            guard let image = self.addPhotoButton.imageView?.image else {return}
            guard let uploadData = UIImageJPEGRepresentation(image, 0.1) else {return}
            let imageFileName = NSUUID().uuidString
            Storage.storage().reference().child("profile-images").child(imageFileName).putData(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error{
                    print("Couldn't upload profile image to Firebase", error)
                    return
                }
                //guard let profileImageURL = metadata?.downloadURL()?.absoluteString  else {return}
              
                Storage.storage().reference().child("profile-images").child(imageFileName).downloadURL(completion: { (url, error) in
                    if error != nil {
                        print(error as Any)
                    } else {
                        guard let imageUrl = url?.absoluteString else { return }
                        self.profilePicUrl = imageUrl
                        print("Successful saving profile image to Firebase: - ", self.profilePicUrl!)
                        //completion(imageUrl)
                    }
                    
                    guard let uid = Auth.auth().currentUser?.uid else {return}
                    
                    let userNameValues = ["username": userName, "profileImageURL": self.profilePicUrl]
                    let values = [uid: userNameValues]
                    Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error, reference) in
                        
                        if let error = error{
                            print("Couldn't save user sign up details to Firebase", error)
                        }
                        print("Successful in saving name and profile pic to Firebase")
                        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
                        mainTabBarController.setUpViewControllers()
                        
                        self.dismiss(animated: true, completion: nil)
                    })
                })
                
            })
            
        }
        
    }
    
    let topContainer: UIView = {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        //containerView.backgroundColor = .red
        return containerView
    }()
    
    let bottomContainer: UIView = {
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = .red
        return containerView
    }()
    
    let stackViewContainer: UIView = {
        let stackViewContainer = UIView()
        stackViewContainer.translatesAutoresizingMaskIntoConstraints = false
        //stackViewContainer.backgroundColor = .blue
        return stackViewContainer
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //view.backgroundColor = .white
        view.backgroundColor = #colorLiteral(red: 0.9591058452, green: 1, blue: 0.9767437409, alpha: 1)
        view.addSubview(topContainer)
        view.addSubview(LoginButton)
        //view.addSubview(bottomContainer)
        view.addSubview(stackViewContainer)
        
        topContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        topContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        topContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        topContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        
        LoginButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        /*
        bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomContainer.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomContainer.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.13).isActive = true
        */
        stackViewContainer.topAnchor.constraint(equalTo: topContainer.bottomAnchor, constant: 10).isActive = true
        stackViewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stackViewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        stackViewContainer.bottomAnchor.constraint(equalTo: LoginButton.topAnchor).isActive = true
        
        //Photo Button
        
        view.addSubview(addPhotoButton)
        
        addPhotoButton.centerXAnchor.constraint(equalTo: topContainer.centerXAnchor).isActive = true
        addPhotoButton.centerYAnchor.constraint(equalTo: topContainer.centerYAnchor, constant: 20).isActive = true
        addPhotoButton.widthAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 1).isActive = true
        addPhotoButton.heightAnchor.constraint(equalTo: topContainer.heightAnchor, multiplier: 1).isActive = true
        //addPhotoButton.topAnchor.constraint(equalTo: topContainer.topAnchor, constant: 20).isActive = true
        addPhotoButton.imageView?.contentMode = .scaleAspectFit
        setUpStackView()


    }
    

    fileprivate func setUpStackView(){
        
        let stackView = UIStackView(arrangedSubviews: [userNameTextField,emailTextField,passwordTextField,signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 10
        stackViewContainer.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: stackViewContainer.topAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: stackViewContainer.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: stackViewContainer.rightAnchor, constant: -40),
            //stackView.heightAnchor.constraint(equalToConstant: 185)
            stackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)

            ])
        
    }


}

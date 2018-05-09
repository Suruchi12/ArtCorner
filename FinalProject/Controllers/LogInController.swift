//
//  LoginController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/26/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase

class LogInController: UIViewController {
    
    lazy var LogoContainerView: UIView = {
       
        let container = UIView()
        
        let logoImageView = UIImageView(image: #imageLiteral(resourceName: "ArtCornerLogo").withRenderingMode(.alwaysOriginal))
        //logoImageView.backgroundColor = .yellow
        logoImageView.contentMode = .scaleToFill
        container.addSubview(logoImageView)
        logoImageView.anchor(top: container.topAnchor, left: container.leftAnchor, bottom: container.bottomAnchor, right: container.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 10, paddingRight: 0, width: 0, height: 0)
        //logoImageView.centerXAnchor.constraint(equalTo: container.centerXAnchor).isActive = true
        container.backgroundColor = .white
        return container
    }()
    
    lazy var stackViewContainer: UIView = {
        
        let container = UIView()
        //container.backgroundColor = .red
        return container
    }()
    
    lazy var signUpButton: UIButton = {
        
        let button = UIButton(type: .system)
        
        let myNormalAttributedTitle = NSMutableAttributedString(string: "Don't have an account? ",
                                                         attributes: [NSAttributedStringKey.foregroundColor: UIColor.lightGray,NSAttributedStringKey.font : UIFont.systemFont(ofSize: 14)])
        myNormalAttributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize:15),NSAttributedStringKey.foregroundColor: #colorLiteral(red: 1, green: 0.3882391449, blue: 0.2153393709, alpha: 1)]))
        
        button.setAttributedTitle(myNormalAttributedTitle, for: .normal)
        
        //button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(presentSignOut), for: .touchUpInside)
        return button
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
    
    lazy var logInButton:UIButton = {
        
        let logInButton = UIButton(type: .system)
        
        //addPhotoButton.backgroundColor = .green
        
        //signUpButton.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.5205263084, blue: 0.5597232519, alpha: 1)
        logInButton.backgroundColor = #colorLiteral(red: 1, green: 0.6077153192, blue: 0.4818769324, alpha: 1)
        logInButton.setTitleColor(.white, for: .normal)
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.setTitle("Log In", for: .normal)
        logInButton.layer.cornerRadius = 5
        logInButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        //logInButton.setTitleColor(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1), for: .normal)
        logInButton.addTarget(self, action: #selector(handleUserLogIn), for: .touchUpInside)
        logInButton.isEnabled = false
        return logInButton
        
    }()
    

   @objc func handleUserLogIn(){
    
      print("logging in")
      guard let email = emailTextField.text else {return}
      guard let password = passwordTextField.text else {return}
    
      Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
        
        if let error = error{
            print("Log in failed",error)
          }
        
        print("Successfully signed in!", user?.uid ?? "")
        
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
        mainTabBarController.setUpViewControllers()
        
        self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    @objc func presentSignOut(){
    
        let signUpController = SignUpViewController()
        //print(navigationController)
        navigationController?.pushViewController(signUpController, animated: true)
        
    }
    @objc func handleInputChange(){
        
        let isInfoValid = emailTextField.text?.count ?? 0 > 0 && passwordTextField.text?.count ?? 0 > 0
        
        if isInfoValid {
            
            logInButton.isEnabled = true
            logInButton.backgroundColor = #colorLiteral(red: 1, green: 0.3882391449, blue: 0.2153393709, alpha: 1)
            logInButton.setTitleColor(.white, for: .normal)
        }
            
        else{
            logInButton.isEnabled = false
            logInButton.backgroundColor = #colorLiteral(red: 1, green: 0.6077153192, blue: 0.4818769324, alpha: 1)
            logInButton.setTitleColor(.white, for: .normal)
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationController?.isNavigationBarHidden = true
        view.addSubview(signUpButton)
        view.addSubview(LogoContainerView)
        view.addSubview(stackViewContainer)
        
        signUpButton.anchor(top: nil, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 50)
        
        LogoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 160)
        
        stackViewContainer.anchor(top: LogoContainerView.bottomAnchor, left: view.safeAreaLayoutGuide.leftAnchor, bottom: signUpButton.topAnchor, right: view.safeAreaLayoutGuide.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setUpStackView()
    }
    
    fileprivate func setUpStackView(){
        
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,logInButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false

        stackViewContainer.addSubview(stackView)
        
//        stackView.anchor(top: bottomContainerView.topAnchor, left: bottomContainerView.leftAnchor, bottom: nil, right: bottomContainerView.rightAnchor, paddingTop: 30, paddingLeft: 40, paddingBottom: 0, paddingRight: 40, width: 0, height: 120)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalTo: stackViewContainer.topAnchor, constant: 20),
            stackView.leftAnchor.constraint(equalTo: stackViewContainer.leftAnchor, constant: 40),
            stackView.rightAnchor.constraint(equalTo: stackViewContainer.rightAnchor, constant: -40),
            //stackView.heightAnchor.constraint(equalToConstant: 185)
            stackView.bottomAnchor.constraint(equalTo: stackView.bottomAnchor)
            
            ])
        
    }
    
    
}

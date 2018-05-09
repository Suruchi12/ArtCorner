//
//  UserProfileViewController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/25/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation

class UserProfileController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate, UserProfileDelegate {
    
    var user: User?
    var userId: String?
    
    var userProfile = UserProfile()
   
    
    let locationManager = CLLocationManager()
    
    fileprivate func setUpLogOutButton(){
         navigationController?.navigationBar.isHidden = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "logOut24").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleLogOut))
        
        
        
    }
    
    
    @objc func handleLogOut(){
        
        print("inside log out function!")
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        present(alertController, animated: true, completion: nil)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_) in
            
            print("performing log out!")
            
            do{
                
                try Auth.auth().signOut()
                //let logInController = LogInController()
                let logInController = LoginGuideViewController()
                let navController = UINavigationController(rootViewController: logInController)
                self.present(navController, animated: true, completion: nil)
                
            } catch let signOutError {
                print("Error while Logging out", signOutError)
            }
            
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
    }

    let topView: UserProfile = {
        
        let topView = UserProfile()
        topView.translatesAutoresizingMaskIntoConstraints = false
        topView.backgroundColor = hexStringToUIColor(hex: "#ADD8E6")
        topView.backgroundColor = UIColor(patternImage: UIImage(named: "aquablue")!)
        
        return topView
    }()
  
    
    let bottomDivider = UIView()
    
   let mapView = MKMapView()
    
    lazy var searchMapBar: UISearchBar = {
        
        let searchBar = UISearchBar()
        searchBar.placeholder = "Enter Location"
        searchBar.tintColor = .gray
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = #colorLiteral(red: 0.9559084141, green: 0.9559084141, blue: 0.9559084141, alpha: 1)
        searchBar.delegate = self
       
        return searchBar
    }()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty{

            locationManager.startUpdatingLocation()
        }
        else{

            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(searchText) { (placemarks:[CLPlacemark]?, error:Error?) in
                if error == nil {
                    
                    let placemark = placemarks?.first
                    
                    let anno = MKPointAnnotation()
                    anno.coordinate = (placemark?.location?.coordinate)!
                    anno.title = searchText
                    
                    let span = MKCoordinateSpanMake(0.075, 0.075)
                    let region = MKCoordinateRegion(center: anno.coordinate, span: span)
                    
                    self.mapView.setRegion(region, animated: true)
                    self.mapView.addAnnotation(anno)
                    self.mapView.selectAnnotation(anno, animated: true)
                    
                    
                    
                }else{
                    print(error?.localizedDescription ?? "error")
                }
            }
        }
    }
    
    fileprivate func setSearchBar(){
        
        guard let currentUserId = Auth.auth().currentUser?.uid else { return }
        
        guard let userId = user?.uid else {return}
        
        if currentUserId == userId{
            
            searchMapBar.isHidden = false
            
        }
        else{
          
            searchMapBar.isHidden = true
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let center = location.coordinate
        let span  = MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
        mapView.showsUserLocation = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userProfile.delegate = self
        
        view.backgroundColor = .white
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.03928178399, green: 0.9340101523, blue: 0.5519225757, alpha: 1)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        fetchUser()
        
        setUpLogOutButton()
       
        
        //Adding SubViews
        view.addSubview(topView)
        view.addSubview(mapView)
        view.addSubview(bottomDivider)
        view.addSubview(searchMapBar)
        
        //topView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 150)
        
       
            topView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            topView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            topView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            topView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.33).isActive = true
        
        
        
            
        topView.setupViews()
        
        mapView.anchor(top: topView.bottomAnchor, left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        //Separator
        bottomDivider.anchor(top: topView.bottomAnchor, left: topView.leftAnchor, bottom: nil, right: topView.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0.5)
        
        //Search Map Bar
        searchMapBar.anchor(top: bottomDivider.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        setSearchBar()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        fetchUser()
        setSearchBar()
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    fileprivate func fetchUser(){
        
        let uid = userId ?? Auth.auth().currentUser?.uid ?? ""
        
        //guard let currentUserID =  Auth.auth().currentUser?.uid else { return }
        
        Database.fetchUserUID(uid: uid) { (user) in
            
            self.user = user
            
            self.navigationItem.title = self.user?.username

            
            //self.collectionView?.reloadData() //renders the header again
            
            self.topView.user = self.user
            self.setSearchBar()
            /*
            guard let profileImageUrl = self.user?.profileImageURL else {return}
            
            self.userNameLabel.text = user.username
            self.profileImage.loadImage(urlString: profileImageUrl)
            */
            //self.view.reloadInputViews()

            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func didEdit() {
        
        
        print("In User profile Controller")
        
        
    }
}

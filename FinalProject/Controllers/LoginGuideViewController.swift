//
//  ViewController.swift
//  Project
//
//  Created by Suruchi Singh on 3/30/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import UIKit



protocol LoginControllerDelegate: class {
    func finishLoggingIn()
    func didStartSignUp()
}


class LoginGuideViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, LoginControllerDelegate{
    
    func didStartSignUp() {
        
        print("inside did start sign up")
        let signUpController = SignUpViewController()
        navigationController?.pushViewController(signUpController, animated: true)
        //present(signUpController, animated: true, completion: nil)
    }
    
    
    func finishLoggingIn() {
        
       
        print("Finish logging in from LoginGuide Controller - delegate incoming!!")
        
        guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? TabBarController else {return}
        mainTabBarController.setUpViewControllers()
        
        self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.dataSource = self
        cv.delegate = self
        cv.isPagingEnabled = true
        return cv
        
    }()
    
    let cellId = "cellId"
    let lastPageCellId = "signUpCellViewId"
    let loginCellId = "loginCellId"
    
    let pages: [Page] = {
        
        let firstPage = Page(title: "Share a Painting!", message: "It's free to share art with your friends", imageName: "FirstScreen")
        let secondPage = Page(title: "Populate your home feed with Art!", message: "Like, Unlike or Review each post. Search Wikipedia for an art piece", imageName: "ThirdScreen")
        
        let thirdPage = Page(title: "Send from your Library", message: "Tap the Add menu to share a painting from your Photo Library", imageName: "SecondScreen1")
        
        return [firstPage, secondPage, thirdPage]
        
    }()
    
    lazy var pageControl: UIPageControl = {
        
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = .lightGray
        pc.numberOfPages = self.pages.count + 1
        pc.currentPageIndicatorTintColor = .orange
        return pc
    }()
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        
        print(UIDevice.current.orientation.isLandscape)
        collectionView.collectionViewLayout.invalidateLayout()
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView.reloadData()
        }
        
    }
    
    //fileprivate func pagingControls() {
    fileprivate func pagingControls(){
        let bottomStackView = UIStackView(arrangedSubviews: [skipButton, pageControl, nextButton])
        
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.distribution = .fillEqually
        
        view.addSubview(bottomStackView)
        pageControlBottomAnchor = NSLayoutConstraint(item: bottomStackView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -15)
        
        NSLayoutConstraint.activate([
            
            //bottomStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomStackView.topAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor),
            bottomStackView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            bottomStackView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            bottomStackView.heightAnchor.constraint(lessThanOrEqualToConstant: 30)
            ])
        NSLayoutConstraint.activate([pageControlBottomAnchor!])
        
        
    }
    
    lazy var skipButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        //let color = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(skipToLoginPage), for: .touchUpInside)
        return button
        
    }()
    
    lazy var nextButton: UIButton = {
        
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        //let color = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        button.setTitleColor(UIColor(red: 247/255, green: 154/255, blue: 27/255, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
        return button
        
    }()
    
    @objc func nextPage(){
        
        if pageControl.currentPage == pages.count{
            return
        }
        
        if pageControl.currentPage == pages.count-1  {
            
            removeButtons()
            
        }
        
        
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    @objc func skipToLoginPage(){
        
        pageControl.currentPage = pages.count - 1
        nextPage()
        
    }
    
    
    func removeButtons(){
        pageControlBottomAnchor?.constant = 25
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    
    override func viewWillAppear(_ animated: Bool) {
        
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.view.layoutSubviews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
        
        view.backgroundColor = .white

        navigationController?.navigationBar.isTranslucent = false
        view.addSubview(collectionView)
        navigationController?.isNavigationBarHidden = true
        
        
        pagingControls()
        
        //collectionView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0)
        collectionView.contentInset = UIEdgeInsetsMake(-40, 0, -20, 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        
        registerCells()
        
    }
    
    
    fileprivate func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    @objc func keyboardShow() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.view.frame = CGRect(x: 0, y: -50, width: self.view.frame.width, height: self.view.frame.height)
            
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
        pageControl.currentPage = pageNumber
        
        pageControlBottomAnchor?.constant = pageNumber == pages.count ? 25 : -15
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        
        
    }
    
    fileprivate func registerCells(){
        
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.register(LastPageCell.self, forCellWithReuseIdentifier: lastPageCellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == pages.count {
            
            view.backgroundColor = .white
            collectionView.backgroundColor = .white
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath) as! LoginCell
            loginCell.delegate = self
            return loginCell

        }
        
        else if indexPath.item == pages.count - 1{
   
            view.backgroundColor = .black
            let signUpCellView = collectionView.dequeueReusableCell(withReuseIdentifier: lastPageCellId, for: indexPath) as! LastPageCell
            //signUpCellView.delegate = self
            signUpCellView.backgroundColor = .black
            collectionView.backgroundColor = .black
            
            return signUpCellView
        }
        
        else{
            
            view.backgroundColor = .white
            collectionView.backgroundColor = .white
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PageCell
            //cell.backgroundColor = .white
            let page = pages[indexPath.item]
            cell.page = page
            return cell
        }
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
   
    
    
    
}



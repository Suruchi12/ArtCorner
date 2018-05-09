//
//  SignUpCellView.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/25/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import AVKit
import AVFoundation
import MediaPlayer

class LastPageCell: UICollectionViewCell{
    
    lazy var titleLabel: UILabel = {
        
        let titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.text = "Welcome to Art Corner"
        titleLabel.lineBreakMode = .byWordWrapping
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont(name: "Futura", size: 36)
        titleLabel.font = UIFont.boldSystemFont(ofSize: 36)
        //titleLabel.textColor = hexStringToUIColor(hex: "00868B")
        titleLabel.textColor = #colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)
        titleLabel.textAlignment = .center
        return titleLabel
    }()
   
    lazy var iv: UIImageView = {
        
        let iconAppImage = UIImageView()
        iconAppImage.image = UIImage(named: "IconApp")
        //iconAppImage.image = #imageLiteral(resourceName: "Blue-Black-White")
        iconAppImage.translatesAutoresizingMaskIntoConstraints = false
        iconAppImage.layer.cornerRadius = 30
        iconAppImage.layer.masksToBounds = true
        iconAppImage.contentMode = .scaleAspectFit
        return iconAppImage
    }()
    
    
    lazy var myPlayerView: UIView = {

        let playerView = UIView()
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.layer.masksToBounds = true
        playerView.backgroundColor = .black
        playerView.contentMode = .scaleAspectFit
        return playerView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        backgroundColor = .black
        self.backgroundColor = .black
        super.backgroundColor = .black
        self.superview?.backgroundColor = .black
        // Start with a generic UIView and add it to the ViewController view
        let myPlayerView = UIView(frame: self.bounds)
        
        addSubview(myPlayerView)
        //myPlayerView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
       
      
        // Use a local or remote URL
        
        var filePath =  Bundle.main.path(forResource: "video1", ofType: "mov")
        
        if UIDevice.current.orientation.isLandscape{
           
            filePath =  Bundle.main.path(forResource: "video1", ofType: "mov")
        }
        else{
            
             filePath =  Bundle.main.path(forResource: "video1", ofType: "mov")
        }
        
        
        let url = URL(fileURLWithPath: filePath!)
        
        // Make a player
        let myPlayer = AVPlayer(url: url)
        myPlayer.actionAtItemEnd = .none
        myPlayer.isMuted = true
        myPlayer.play()
        
        // Make the AVPlayerLayer and add it to myPlayerView's layer
        let avLayer = AVPlayerLayer(player: myPlayer)
        
        avLayer.frame = myPlayerView.layer.bounds
        avLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avLayer.masksToBounds = true
        //avLayer.layoutIfNeeded()
        myPlayerView.layer.addSublayer(avLayer)
        
        
        //Loop the video
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: myPlayer.currentItem, queue: nil) { (_) in
            myPlayer.seek(to: kCMTimeZero)
            myPlayer.play()
        }
        
        
        
        
        
        let stackView = UIStackView(arrangedSubviews: [titleLabel,iv])
        
        myPlayerView.addSubview(stackView)
        
        stackView.axis = .vertical
        stackView.spacing = 15
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        //stackView.widthAnchor.constraint(equalTo: widthAnchor,  constant: -100).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        myPlayerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimation)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapAnimation)))
        
    }
    
    //weak var delegate: loginGuideDelegate?
    
    func startSignUp(){
    
        print("call sign up")
        //delegate?.didStart()
    }
    
    @objc func handleTapAnimation(){
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.titleLabel.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { (_) in
            
            UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.titleLabel.transform = self.titleLabel.transform.translatedBy(x: 0, y: -400)
            })//, completion: <#T##((Bool) -> Void)?##((Bool) -> Void)?##(Bool) -> Void#>)
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.iv.transform = CGAffineTransform(translationX: -30, y: 0)
            
        }) { (_) in
            
            UIView.animate(withDuration: 1, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                self.iv.transform = self.iv.transform.translatedBy(x: 0, y: -800)
            }){ (ok) in
                print("Ended \(ok)")
                 self.startSignUp()
                
            }
            
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  ReviewCell.swift
//  FinalProject
//
//  Created by Suruchi Singh on 5/2/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class ReviewCell:UICollectionViewCell{
    
    var review: Review?{
        
        didSet{
            
            guard let review = review else {return}
            let userName = review.user?.username
            
            let attributedText = NSMutableAttributedString(string: userName!, attributes: [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 14)])
            
            attributedText.append(NSAttributedString(string: " " + (review.text)!, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14)]))
            
                
            textView.attributedText = attributedText
            
            let imageUrl = review.user?.profileImageURL
            profileView.loadImage(urlString: imageUrl!)
        }
    }
    
    lazy var textView: UITextView = {
       
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        //textLabel.backgroundColor = .clear
        return textView
        
    }()
    
    lazy var profileView: CustomImageView = {
       
        let iv = CustomImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        return iv
        
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        //backgroundColor = .yellow
        addSubview(profileView)
        addSubview(textView)
        profileView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 40, height: 40)
        profileView.layer.cornerRadius = 20
        
        
        
        textView.anchor(top: topAnchor, left: profileView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 4 , paddingLeft: 4, paddingBottom: 4, paddingRight: 4, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

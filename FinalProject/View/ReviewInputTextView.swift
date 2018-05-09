//
//  ReviewInputTextView.swift
//  FinalProject
//
//  Created by Suruchi Singh on 5/3/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class ReviewInputTextView: UITextView {
    
    
    fileprivate let placeholderTextLabel: UILabel = {
       
        let label = UILabel()
        label.text = "Enter your Review"
        label.textColor = UIColor.lightGray
        //label.textColor = .clear
        return label
        
    }()
    
    func showPlaceholder(){
    
        placeholderTextLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: .UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderTextLabel)
        placeholderTextLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 0, paddingRight: 0, width: 0, height: 0 )
        
    }
    
    @objc func handleTextChange(){
    
        placeholderTextLabel.isHidden = !self.text.isEmpty
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

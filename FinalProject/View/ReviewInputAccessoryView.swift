//
//  ReviewInputAccessoryView.swift
//  FinalProject
//
//  Created by Suruchi Singh on 5/2/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

protocol ReviewInputViewDelegate {
    
    func didSendReview(for review: String)
}

class ReviewInputAccessoryView: UICollectionViewCell {
    
    var delegate: ReviewInputViewDelegate?
    
    
    func clearReviewTextField(){
        
        reviewTextField.text = nil
        reviewTextField.showPlaceholder()
    }
    
    fileprivate lazy var sendButton: UIButton = {
        
        let sb = UIButton(type: .system)
        sb.setTitle("Send", for: .normal)
        sb.setTitleColor(.black, for: .normal)
        sb.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        sb.addTarget(self, action: #selector(handleSendReview), for: .touchUpInside)
        
        return sb
    }()
    
    fileprivate lazy var reviewTextField: ReviewInputTextView = {
        
        let tv = ReviewInputTextView()
        //tv.placeholder = "Add a Review"
        tv.isScrollEnabled = false
        tv.font = UIFont.systemFont(ofSize: 18)
        //tv.backgroundColor = .clear
        return tv
    }()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        backgroundColor = .white
        
        autoresizingMask = .flexibleHeight
        
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 12, width: 50, height: 50)
        

        addSubview(reviewTextField)
        if #available(iOS 11.0, *) {
        
            reviewTextField.anchor(top: topAnchor, left: leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: sendButton.leftAnchor, paddingTop: 0, paddingLeft: 12, paddingBottom: 0, paddingRight: 0, width: 0, height: 0 )
        }
        else{
            
        }
       setDivider()
        
        
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    
    fileprivate func setDivider(){
        
        let divider = UIView()
        addSubview(divider)
        divider.backgroundColor = .gray
        divider.anchor(top: topAnchor, left: leftAnchor , bottom: nil, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 1)
    }
    
    @objc func handleSendReview(){
        
        print("sending review from input accessory view")
        guard let reviewText = reviewTextField.text else {return }
        delegate?.didSendReview(for: reviewText)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

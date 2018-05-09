//
//  PageCell.swift
//  Project
//
//  Created by Suruchi Singh on 4/1/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class PageCell: UICollectionViewCell{
    
    var page: Page? {
        didSet {
            
            guard let page = page else {
                return
            }
            
            var imageName = page.imageName
            
            if UIDevice.current.orientation.isLandscape{
                imageName += "_Landscape"
            }
            
            imageView.image = UIImage(named: imageName)
            
            // imageView.image = UIImage(named: page.imageName)
            
            let color = UIColor(white: 0.2, alpha: 1)
            
            let attributedText = NSMutableAttributedString(string: page.title, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.medium), NSAttributedStringKey.foregroundColor: color])
            
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor: color]))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            
            let length = attributedText.string.count
            
            attributedText.addAttribute(NSAttributedStringKey.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: length ))
            
            textView.attributedText = attributedText
            textView.text = page.title + "\n\n" + page.message
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    let imageView:UIImageView = {
        
        let iv = UIImageView()
        //iv.contentMode = .scaleAspectFit
        iv.contentMode = .scaleAspectFill
        //iv.backgroundColor = .yellow
        iv.image = UIImage(named: "FirstScreen")
        iv.clipsToBounds = true
        return iv
    }()
    
    let textView:UITextView = {
        
        let tv = UITextView()
        tv.text = "Sample Text for now"
        tv.isEditable = false
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        return tv
        
    }()
    
    let lineSeparatorView: UIView = {
        
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
        
    }()
    
    func setupViews(){
        
        backgroundColor = .white
        let topImageContainerView = UIView()
        addSubview(topImageContainerView)
        
        addSubview(textView)
        
        //addSubview(lineSeparatorView)
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        topImageContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topImageContainerView.leftAnchor.constraint(equalTo: safeAreaLayoutGuide.leftAnchor).isActive = true
        topImageContainerView.rightAnchor.constraint(equalTo: safeAreaLayoutGuide.rightAnchor).isActive = true
        topImageContainerView.bottomAnchor.constraint(equalTo: textView.topAnchor).isActive = true
        
        topImageContainerView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(lessThanOrEqualTo: topImageContainerView.heightAnchor).isActive = true
        imageView.widthAnchor.constraint(lessThanOrEqualTo: topImageContainerView.widthAnchor).isActive = true
        
        
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.anchorWithConstantsToTop(top: nil, left: safeAreaLayoutGuide.leftAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, right: safeAreaLayoutGuide.rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 40, rightConstant: 16)
        
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        //        lineSeparatorView.anchorToTop(top: nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        //        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

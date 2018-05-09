//
//  PhotoSelectorCell.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/27/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit

class PhotoSelectorCell: UICollectionViewCell {
    
    let photoImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
    
        super.init(frame: frame)
        backgroundColor = .white
        
        addSubview(photoImageView)
        
        photoImageView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

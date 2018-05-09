//
//  PhotoSelectorController.swift
//  FinalProject
//
//  Created by Suruchi Singh on 4/27/18.
//  Copyright © 2018 Suruchi Singh. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoSelectorController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    let headerId = "headerId"
    
    var images = [UIImage]()
    var selectedImage: UIImage?
    var assets = [PHAsset]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        setUpNavigationButtons()
        navigationController?.navigationBar.backgroundColor = #colorLiteral(red: 0.03928178399, green: 0.9340101523, blue: 0.5519225757, alpha: 1)

        collectionView?.register(PhotoSelectorCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(PhotoSelectorHeaderCell.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        
        fetchPhotos()
    }
    
    //Select an Image
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.selectedImage = images[indexPath.item]
        //print(selectedImage as Any)
        self.collectionView?.reloadData() //will reload/return header again
        
        //scrolls the image to header after selecting an image
        let indexPath = IndexPath(item: 0, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
        
    }
    
    //Fetch Photos from Library
    fileprivate func fetchPhotos(){
    
        print("Fetching Photos from Framework")
        let fetchOptions = PHFetchOptions()
        fetchOptions.fetchLimit = 30 //number of photos to fetch
        
        let sortDescriptors = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchOptions.sortDescriptors = [sortDescriptors]
        
        
        let allPhotos = PHAsset.fetchAssets(with: .image, options: fetchOptions)
        
        DispatchQueue.global(qos: .background).async {
            
            allPhotos.enumerateObjects { (asset, count, stop) in
                
                //print(asset)
                
                let imageManager = PHImageManager.default()
                let targetSize = CGSize(width: 200, height: 200)
                let options = PHImageRequestOptions()
                options.isSynchronous = true
                
                imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFit, options: options, resultHandler: { (image, info) in
                    
                    if let image = image{
                        self.images.append(image)
                        self.assets.append(asset)
                        //print(image)
                        
                        if self.selectedImage == nil{
                            self.selectedImage = image //shows the first image
                        }
                    }
                    
                    if count == allPhotos.count - 1 {
                        
                        DispatchQueue.main.async {
                            self.collectionView?.reloadData()
                        }
                    }
                })
            }
        }
    }
    
    //Header Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        let width = view.frame.width
        return CGSize(width: width, height: width)
    }
    
    //Inset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 0)
    }
    
    //Creating Header Cell
    var header: PhotoSelectorHeaderCell?
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! PhotoSelectorHeaderCell
        //header.backgroundColor = .red
        self.header = header
        header.photoImageView.image = selectedImage
        
        if let selectedImage = selectedImage{
            
            if let index = self.images.index(of: selectedImage){
                let selectedAsset = self.assets[index]
                
                let imageManager = PHImageManager.default()
                
                let targetSize = CGSize(width: 600, height: 600)
                imageManager.requestImage(for: selectedAsset, targetSize: targetSize, contentMode: .default, options: nil) { (image, info) in
                    
                    header.photoImageView.image = image

                }
            }
        }
        return header
    }
    
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //Number of rows in Library
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    //Creating collection View cells below header
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! PhotoSelectorCell
        //cell.backgroundColor = .blue
        cell.photoImageView.image = images[indexPath.item]
        
        return cell
    }
    
    //size of each photo image in the collection view
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (view.frame.width - 3)/4
        
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    //Setting Next and Cancel buttons in the navigation bars
    fileprivate func setUpNavigationButtons(){
        
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(handleNext))

    }
    
    @objc func handleCancel(){
        
        dismiss(animated: true, completion: nil)
    }
    @objc func handleNext(){
        
        //dismiss(animated: true, completion: nil)
        let sharePhotoController = SharePhotoController()
        sharePhotoController.selectedImage = header?.photoImageView.image
        navigationController?.pushViewController(sharePhotoController, animated: true)
    }
    
}

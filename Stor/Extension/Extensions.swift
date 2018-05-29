//
//  Extensions.swift
//  Stor
//
//  Created by David Ho on 5/25/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase

let profileImageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadProfilePicture() {
        if let cachedImage = profileImageCache.object(forKey: globalVariablesViewController.profilePicString as AnyObject){
            self.image = cachedImage as! UIImage
            print("Got Cache? Get Cache")
            return
        }
        
        
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                globalVariablesViewController.username = (dictionary["name"] as? String)!
                globalVariablesViewController.profilePicString = (dictionary["profilePicture"] as? String)!
            }
        }, withCancel: nil)
        
        if let imageURL = URL(string: globalVariablesViewController.profilePicString){
            globalVariablesViewController.profilePicData = NSData(contentsOf: imageURL) as Data!
            
            if let downloadedImage = UIImage(data: globalVariablesViewController.profilePicData){
                profileImageCache.setObject(downloadedImage, forKey: globalVariablesViewController.profilePicString as AnyObject)
                self.image = downloadedImage
            }
        }
    }
    func forceLoadProfilePic(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                globalVariablesViewController.username = (dictionary["name"] as? String)!
                globalVariablesViewController.profilePicString = (dictionary["profilePicture"] as? String)!
            }
        }, withCancel: nil)
        
        if let imageURL = URL(string: globalVariablesViewController.profilePicString){
            globalVariablesViewController.profilePicData = NSData(contentsOf: imageURL) as Data!
            
            if let downloadedImage = UIImage(data: globalVariablesViewController.profilePicData){
                profileImageCache.setObject(downloadedImage, forKey: globalVariablesViewController.profilePicString as AnyObject)
                self.image = downloadedImage
            }
        }
    }
}




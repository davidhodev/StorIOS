
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
        URLSession.shared.dataTask(with: NSURL(string: globalVariablesViewController.profilePicString)! as URL, completionHandler: { (data, response, error) -> Void in
            
            Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                globalVariablesViewController.username = (dictionary["name"] as? String)!
                globalVariablesViewController.ratingNumber = ((dictionary["rating"]) as? NSNumber)!
                globalVariablesViewController.profilePicString = (dictionary["profilePicture"] as? String)!
            }
        }, withCancel: nil)
        
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                profileImageCache.setObject(image!, forKey: globalVariablesViewController.profilePicString as AnyObject)
                self.image = image
            })
            
        }).resume()
        
    }
    func forceLoadProfilePic(){
        let uid = Auth.auth().currentUser?.uid
       URLSession.shared.dataTask(with: NSURL(string: globalVariablesViewController.profilePicString)! as URL, completionHandler: { (data, response, error) -> Void in
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String:Any] {
                globalVariablesViewController.username = (dictionary["name"] as? String)!
                globalVariablesViewController.profilePicString = (dictionary["profilePicture"] as? String)!
            }
        }, withCancel: nil)
        
        
            
            if error != nil {
                print(error)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.image = image
            })
            
        }).resume()
        
        
    }
}




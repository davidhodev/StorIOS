//
//  Extensions.swift
//  Stor
//
//  Created by David Ho on 5/25/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import Foundation
import UIKit

let profileImageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadProfilePicture() {
        if let cachedImage = profileImageCache.object(forKey: globalVariablesViewController.profilePicString as AnyObject){
            self.image = cachedImage as! UIImage
            print("Got Cache? Get Cache")
            return
        }
        
        
        if let imageURL = URL(string: globalVariablesViewController.profilePicString){
            globalVariablesViewController.profilePicData = NSData(contentsOf: imageURL) as Data!
            
            if let downloadedImage = UIImage(data: globalVariablesViewController.profilePicData){
                profileImageCache.setObject(downloadedImage, forKey: globalVariablesViewController.profilePicString as AnyObject)
                self.image = downloadedImage
            }
        }
    }
}


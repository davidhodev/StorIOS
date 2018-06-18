//
//  providerPotentialUser.swift
//  Stor
//
//  Created by David Ho on 6/14/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class providerPotentialUser: NSObject {
    var providerID: String?
    var storageID: String?
    var userID: String?
    var price: NSMutableAttributedString?
    var dimensionsString: NSMutableAttributedString?
    var cubicString: NSMutableAttributedString?
    var rating: NSMutableAttributedString?
    var providerProfile: UIImage?
    var storagePhoto: UIImage?
    var name: NSMutableAttributedString?
    var phone: NSMutableAttributedString?
    var inUse: Bool?
    var dropOff: String?
    
    
    func getName(){
        if let user = Auth.auth().currentUser{
            Database.database().reference().child("Users").child(userID!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let tempName = dictionary["name"] as? String
                    let fontAddress:UIFont? = UIFont(name: "Dosis-Medium", size:16)
                    let addressAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempName!, attributes: [.font: fontAddress!])
                    self.name = addressAttString
                    
                    let ratingString = String(describing: dictionary["rating"]!)
                    let roundedRating = (Double(ratingString)! * 100).rounded()/100
                    let ratingTemp = String(format: "%.2f", roundedRating)
                    // MEDIUM
                    let fontRating: UIFont? = UIFont(name: "Dosis-Medium", size:14)
                    let ratingAttString:NSMutableAttributedString = NSMutableAttributedString(string: ratingTemp, attributes: [.font: fontRating!])
                    self.rating = ratingAttString
                    
                    let tempPhone = dictionary["phone"] as? String
                    print("TEMP PHONE: ", tempPhone)
                    let fontPhone:UIFont? = UIFont(name: "Dosis-Medium", size:16)
                    let phoneAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempPhone!, attributes: [.font: fontPhone!])
                    self.phone = phoneAttString
                    
                    if let timesDictionary = dictionary["pendingStorage"] as? [String: Any]{
                    
                        let finalTimeDictionary = timesDictionary[self.storageID!] as? [String: Any]
                        self.dropOff = finalTimeDictionary!["timeSlotString"] as! String
                    
                    }
                    
                    
                    
//                    print(timesDictionary!)
//                    let userStorageInfo = timesDictionary![self.userID!] as? [String: Any]
//                    print(userStorageInfo!)
//                    let timeSlotTemp = userStorageInfo!["timeSlotString"]
//                    print("TIME SLOT", timeSlotTemp)
                    
                    
                    
                    URLSession.shared.dataTask(with: NSURL(string: dictionary["profilePicture"] as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.providerProfile = UIImage(data: data!)
                        })
                        
                    }).resume()
                }
            })
        }
    }
    
    func getData(){
        print("=============================GET DATA==========================")
        if let user = Auth.auth().currentUser{
            Database.database().reference().child("Users").child(userID!).observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let tempPhone = dictionary["phone"] as? String
                    print("TEMP PHONE: ", tempPhone)
                    let fontAddress:UIFont? = UIFont(name: "Dosis-Medium", size:16)
                    let phoneAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempPhone!, attributes: [.font: fontAddress!])
                    self.phone = phoneAttString
                    
                    let timesDictionary = dictionary["pendingStorage"] as? [String: Any]
                    print("TIMES DICTIONARY: ", timesDictionary)
                }
            }
        )}
        
    }
    
}


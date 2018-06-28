//
//  myCurrentUser.swift
//  Stor
//
//  Created by David Ho on 6/7/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class myCurrentUser: NSObject {
    var providerID: String?
    var storageID: String?
    var address: String?
    var price: NSMutableAttributedString?
    var dimensionsString: NSMutableAttributedString?
    var cubicString: NSMutableAttributedString?
    var rating: NSMutableAttributedString?
    var providerProfile: UIImage?
    var storagePhoto: UIImage?
    var name: NSMutableAttributedString?
    var dropOffTime: NSMutableAttributedString?
    var status: String?
    
    
    func getAddress(){
        if let user = Auth.auth().currentUser{
           print("TEST", providerID!)
            Database.database().reference().child("Providers").child(providerID!).child("storageInUse").observe(.childAdded, with: { (snapshot) in
                print("GET ADDESS SNAPSHOT: ", snapshot)
                print(snapshot.key)
                self.storageID = snapshot.key
                if let dictionary = snapshot.value as? [String: Any]{
                    print(dictionary)
                    self.address = dictionary["Address"] as? String
                }
            })
        }
    }
    
    func getData(){
        if let user = Auth.auth().currentUser{
            Database.database().reference().child("Providers").child(providerID!).child("storageInUse").observe(.childAdded, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let priceString = String(describing: dictionary["Price"]!)
                    if let outputPrice = (Double(priceString)){
                        let finalPrice = Int(round(outputPrice))
                        var finalPriceRoundedString = "$ "
                        finalPriceRoundedString += String(describing: finalPrice)
                        finalPriceRoundedString += " /mo"
                        let font:UIFont? = UIFont(name: "Dosis-Bold", size:24)
                        let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                        let fontSmall:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                        
                        let attString:NSMutableAttributedString = NSMutableAttributedString(string: finalPriceRoundedString, attributes: [.font:font!])
                        attString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:0,length:1))
                        attString.setAttributes([.font:fontSmall!,.baselineOffset:-1], range: NSRange(location:(finalPriceRoundedString.count)-3,length:3))
                        self.price = attString
                    }
                    
                    self.status = String(describing: dictionary["status"]!)
                    
                    
                    
                    
                    
                    var dimensionsString = String(describing: dictionary["Length"]!)
                    dimensionsString += "' X "
                    dimensionsString += String(describing: dictionary["Width"]!)
                    dimensionsString += "'"
                    let dimensionsTemp = dimensionsString
                    // maybe change this
                    let fontDimensions: UIFont? = UIFont(name: "Dosis-Bold", size:16)
                    let dimensionsAttString:NSMutableAttributedString = NSMutableAttributedString(string: dimensionsTemp, attributes: [.font: fontDimensions!])
                    self.dimensionsString = dimensionsAttString
                    
                    var cubicFeetNumber = Int(String(describing:dictionary["Length"]!))
                    cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Width"]!))!)
                    cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Height"]!))!)
                    var cubicFeetString = String(describing: cubicFeetNumber!)
                    cubicFeetString += " ft3"
                    
                    let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                    let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                    
                    let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: cubicFeetString, attributes: [.font:font!])
                    cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:(cubicFeetString.count)-1,length:1))
                    
                    self.cubicString = cubicFeetAttString
                    
                    if let timeDictionary = dictionary["time"] as? [String: Any]{
                        var dropOffTimeString = "Drop Off Time: "
                        dropOffTimeString += (timeDictionary.first?.value)! as! String
                        
                        let timeFont: UIFont? = UIFont(name: "Dosis-Regular", size:14)
                        let dropOffAttString:NSMutableAttributedString = NSMutableAttributedString(string: dropOffTimeString, attributes: [.font:timeFont!])
                        self.dropOffTime = dropOffAttString
                       
                        
                    }
                    
                    
                    if let photoDictionary = dictionary["Photos"] as? [String: Any] {
                        let myURL = (photoDictionary.first?.value)!
                        
                        URLSession.shared.dataTask(with: NSURL(string: myURL as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                            
                            if error != nil {
                                print(error)
                                return
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.storagePhoto = UIImage(data: data!)
                            })
                        }).resume()
                    }
                    
                    
                }
            })
            
            Database.database().reference().child("Providers").child(providerID!).child("personalInfo").observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let ratingString = String(describing: dictionary["rating"]!)
                    let roundedRating = (Double(ratingString)! * 100).rounded()/100
                    let ratingTemp = String(format: "%.2f", roundedRating)
                    // MEDIUM
                    let fontRating: UIFont? = UIFont(name: "Dosis-Medium", size:14)
                    let ratingAttString:NSMutableAttributedString = NSMutableAttributedString(string: ratingTemp, attributes: [.font: fontRating!])
                    self.rating = ratingAttString
                    
                    let fullName = dictionary["Name"] as? String
//                    let fullNameArr = fullName?.split(separator: " ")
//                    let firstName = fullNameArr![0]
//                    var lastName: String?
//                    if (fullNameArr!.count > 2){
//                        lastName = String(describing: fullNameArr![1])
//                        lastName = lastName! + " " + String(describing: fullNameArr![2])
//                    }
//                    else{
//                        lastName = String(describing: fullNameArr![1])
//                    }
//                    var finalName = firstName
//                    finalName += "\n"
//                    finalName += lastName!
//                    let tempName = String(describing: finalName!)
                    let fontName:UIFont? = UIFont(name: "Dosis-Regular", size:18)
                    let nameAttString:NSMutableAttributedString = NSMutableAttributedString(string: fullName!, attributes: [.font:fontName!])
                    self.name = nameAttString
                    
                    
                    
                    URLSession.shared.dataTask(with: NSURL(string: dictionary["profileImage"] as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                        if error != nil {
                            print(error)
                            return
                        }
                        DispatchQueue.main.async(execute: { () -> Void in
                            self.providerProfile = UIImage(data: data!)
                        })
                        
                    }).resume()
                    
                    
                }
            }, withCancel: nil)
        }
        
    }
}

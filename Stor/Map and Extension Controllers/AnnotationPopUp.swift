//
//  AnnotationPopUp.swift
//  Stor
//
//  Created by Cole Feldman on 5/30/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase
import CoreLocation


class AnnotationPopUp: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var providerNameLabel: UILabel! // Done
    @IBOutlet weak var providerRatingLabel: UILabel! // Done
    @IBOutlet weak var providerDescriptionLabel: UILabel! // Done
    @IBOutlet weak var providerAddressLabel: UILabel! // Done
    @IBOutlet weak var providerDistanceLabel: UILabel!
    @IBOutlet weak var providerPriceLabel: UILabel! // Done
    @IBOutlet weak var providerSizeLabel: UILabel!
    
    
    var providerAddress: String?
    var providerID: String?
    var storageID: String?
    var providerLocation: CLLocationCoordinate2D?
    var userLocation: CLLocation?
    var outputDistance: String?
    
    @IBAction func Exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Providers").child(providerID!).child("currentStorage").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                self.providerAddressLabel.text = dictionary["Address"] as? String
                self.providerDescriptionLabel.text = dictionary["Subtitle"] as? String
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
                    self.providerPriceLabel.attributedText = attString
                    
                }
                var dimensionsString = String(describing: dictionary["Length"]!)
                dimensionsString += " X "
                dimensionsString += String(describing: dictionary["Width"]!)
                self.providerSizeLabel.text = dimensionsString
                
                let locationProvider = CLLocation(latitude: (self.providerLocation?.latitude)!, longitude: (self.providerLocation?.longitude)!)
                
                let distance = self.userLocation?.distance(from: locationProvider)
                if (Int(distance!) < 1609){
                    self.outputDistance = "Less than one mile"
                }
                else{
                    let finalDistance = Double(distance!) / 1609
                    self.outputDistance = String(format: "%.1f", finalDistance)
                }
                self.providerDistanceLabel.text = self.outputDistance
                
                
            }
        }, withCancel: nil)
        
        Database.database().reference().child("Providers").child(providerID!).child("personalInfo").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let ratingString = String(describing: dictionary["rating"]!)
                let roundedRating = (Double(ratingString)! * 100).rounded()/100
                self.providerRatingLabel.text = String(format: "%.2f", roundedRating)
                
                let fullName = dictionary["Name"] as? String
                let fullNameArr = fullName?.split(separator: " ")
                let firstName = fullNameArr![0]
//                var lastName: String?
//                if (fullNameArr!.count > 2){
//                    lastName = String(describing: fullNameArr![1])
//                    lastName += " "
//                    lastName += String(describing: fullNameArr![2])
//                }
                let lastName = fullNameArr!.count > 1 ? fullNameArr![1] : nil
                var finalName = firstName
                finalName += "\n"
                finalName += lastName!
                print(firstName)
                
                
                self.providerNameLabel.text = String(describing: finalName) //dictionary["Name"] as? String
                
                
                
            }
        }, withCancel: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

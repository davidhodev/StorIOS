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
                    let finalPrice = (outputPrice*100).rounded()/100
                    self.providerPriceLabel.text = String(format: "%.2f", finalPrice)
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
                    self.outputDistance = String(format: "%.2f", finalDistance)
                }
                self.providerDistanceLabel.text = self.outputDistance
                
                
            }
        }, withCancel: nil)
        
        Database.database().reference().child("Providers").child(providerID!).child("personalInfo").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let ratingString = String(describing: dictionary["rating"]!)
                let roundedRating = (Double(ratingString)! * 100).rounded()/100
                self.providerRatingLabel.text = String(format: "%.2f", roundedRating)
                self.providerNameLabel.text = dictionary["Name"] as? String
                
                
                
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

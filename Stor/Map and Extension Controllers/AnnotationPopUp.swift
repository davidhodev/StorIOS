//
//  AnnotationPopUp.swift
//  Stor
//
//  Created by Cole Feldman on 5/30/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation


class AnnotationPopUp: UIViewController, CLLocationManagerDelegate, UIScrollViewDelegate {

    @IBOutlet weak var providerNameLabel: UILabel! // Done
    @IBOutlet weak var providerRatingLabel: UILabel! // Done
    @IBOutlet weak var providerAddressLabel: UILabel! // Done
    @IBOutlet weak var providerDistanceLabel: UILabel!
    @IBOutlet weak var providerPriceLabel: UILabel! // Done
    @IBOutlet weak var providerSizeLabel: UILabel!
    @IBOutlet weak var providerProfileImage: UIImageView!
    @IBOutlet weak var addToListButton: UIButton!
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var featurePageControl: UIPageControl!
    @IBOutlet weak var descriptionScrollView: UIScrollView!
    @IBOutlet weak var cubicFeetLabel: UILabel!
    
    var providerAddress: String?
    var providerID: String?
    var storageID: String?
    var providerLocation: CLLocationCoordinate2D?
    var userLocation: CLLocation?
    var outputDistance: String?
    
    
    @IBAction func Exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func connectButton(_ sender: Any) {
        print("CONNECT")
    }
    @IBAction func addToListButtonPressed(_ sender: Any) {
        print("ADD TO LIST")
//        if let user = Auth.auth().currentUser{
//            
//        }
        
        
    }
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageScrollView.delegate = self
        descriptionScrollView.delegate = self
        Database.database().reference().child("Providers").child(providerID!).child("currentStorage").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                self.providerAddressLabel.text = dictionary["Address"] as? String
                let priceString = String(describing: dictionary["Price"]!)
                let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.descriptionScrollView.frame.size.width, height: CGFloat.greatestFiniteMagnitude)) // resize
                label.numberOfLines = 0
                label.lineBreakMode = NSLineBreakMode.byWordWrapping
                label.font = UIFont(name: "Dosis", size: 15.0)
                label.text = dictionary["Subtitle"] as? String
                label.alpha = 1.0
                label.sizeToFit()
                label.textColor = UIColor(red: 42/170, green: 39/170, blue: 89/170, alpha: 0.7)
                

                self.descriptionScrollView.contentSize = CGSize(width: self.descriptionScrollView.bounds.width, height: label.frame.height + 5)
                self.descriptionScrollView.addSubview(label)
                
                
                
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
                dimensionsString += "' X "
                dimensionsString += String(describing: dictionary["Width"]!)
                dimensionsString += "'"
                self.providerSizeLabel.text = dimensionsString
                
                var cubicFeetNumber = Int(String(describing:dictionary["Length"]!))
                cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Width"]!))!)
                cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Height"]!))!)
                var cubicFeetString = String(describing: cubicFeetNumber!)
                cubicFeetString += " ft3"
                
                let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                
                let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: cubicFeetString, attributes: [.font:font!])
                cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:(cubicFeetString.count)-1,length:1))
                self.cubicFeetLabel.attributedText = cubicFeetAttString
                print(self.cubicFeetLabel.attributedText)
                
                
                
                
                
                
                let locationProvider = CLLocation(latitude: (self.providerLocation?.latitude)!, longitude: (self.providerLocation?.longitude)!)
                
                let distance = self.userLocation?.distance(from: locationProvider)
                if (Int(distance!) < 1609){
                    self.outputDistance = "Less than one mile"
                }
                else{
                    let finalDistance = Double(distance!) / 1609
                    var milesAway = String(format: "%.1f", finalDistance)
                    milesAway = milesAway + " miles away"
                    self.outputDistance = milesAway
                }
                self.providerDistanceLabel.text = self.outputDistance
                
                if let photoDictionary = dictionary["Photos"] as? [String: Any] {
                    self.featurePageControl.numberOfPages = photoDictionary.count
                    self.imageScrollView.isPagingEnabled = true
                    self.imageScrollView.contentSize = CGSize(width: self.imageScrollView.bounds.width * CGFloat(photoDictionary.count), height: 122)
                    self.imageScrollView.showsHorizontalScrollIndicator = true
                    self.imageScrollView.showsVerticalScrollIndicator = false
                    for (index, feature) in photoDictionary.enumerated(){
                        URLSession.shared.dataTask(with: NSURL(string: feature.value as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                            
                            if error != nil {
                                print(error)
                                return
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                let myImage = UIImage(data: data!)
                                let myImageView:UIImageView = UIImageView()
                                myImageView.frame.size.width = self.view.bounds.size.width
                                myImageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                                myImageView.image = myImage
                                
                                let xPosition = (self.imageScrollView.frame.width) * CGFloat(index)
                                myImageView.frame = CGRect(x: xPosition, y: 0, width: self.imageScrollView.frame.width, height: self.imageScrollView.frame.height)
                                self.imageScrollView.layer.cornerRadius = 8
                                
                                self.imageScrollView.addSubview(myImageView)
                            })
                            
                        }).resume()
                    }
                }
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
                var lastName: String?
                if (fullNameArr!.count > 2){
                    lastName = String(describing: fullNameArr![1])
                    lastName = lastName! + " " + String(describing: fullNameArr![2])
                }
                else{
                    lastName = String(describing: fullNameArr![1])
                }
                var finalName = firstName
                finalName += "\n"
                finalName += lastName!
                self.providerNameLabel.text = String(describing: finalName)
                
                
                
                URLSession.shared.dataTask(with: NSURL(string: dictionary["profileImage"] as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                    
                    if error != nil {
                        print(error)
                        return
                    }
                    DispatchQueue.main.async(execute: { () -> Void in
                        
                        let lineWidth = CGFloat(7.0)
                        let rect = CGRect(x: 0, y: 0.0, width: 50, height: 54)
                        let sides = 6
                        
                        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 5.0, rotationOffset: CGFloat(.pi / 2.0))
                        
                        let borderLayer = CAShapeLayer()
                        borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
                        borderLayer.path = path.cgPath
                        borderLayer.lineWidth = lineWidth
                        borderLayer.lineJoin = kCALineJoinRound
                        borderLayer.lineCap = kCALineCapRound
                        borderLayer.strokeColor = UIColor.black.cgColor
                        borderLayer.fillColor = UIColor.white.cgColor
                        
                        let hexagon = createImage(layer: borderLayer)
                        
                        self.providerProfileImage.contentMode = .scaleAspectFill
                        self.providerProfileImage.layer.masksToBounds = false
                        self.providerProfileImage.layer.mask = borderLayer
                        let image = UIImage(data: data!)
                        self.providerProfileImage.image = image
                    })
                    
                }).resume()
                
                
            }
        }, withCancel: nil)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        featurePageControl.currentPage = Int(page)
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

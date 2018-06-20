//
//  addListingViewController.swift
//  Stor
//
//  Created by David Ho on 6/18/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class addListingViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    // blur effects and window variables
    @IBOutlet var dimensionsView: UIView!
    @IBOutlet var descriptionView: UIView!
    @IBOutlet weak var userDescriptionText: UITextField!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet var availabilityView: UIView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    var blurEffect: UIVisualEffect!
    
    @IBAction func addListingButton(_ sender: Any) {
        print("add Listing!")
    }
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //takes you to dimensions pop up
    @IBAction func addDimensionsPressed(_ sender: UIButton) {
        animateInDimensions()
    }
    @IBAction func exitDimensions(_ sender: UIButton) {
        animateOutDimensions()
    }
    
    //takes you to description pop up
    @IBAction func addDescriptionPressed(_ sender: UIButton) {
        animateInDescriptions()
    }
    
    @IBAction func exitDescription(_ sender: UIButton) {
        descriptionLabel.text = userDescriptionText.text
        animateOutDescriptions()
    }
    
    //takes you to availability pop up
    @IBAction func addAvailabilityPressed(_ sender: UIButton) {
        animateInAvailability()
    }
    
    @IBAction func exitAvailability(_ sender: UIButton) {
        animateOutAvailability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //recording blur effect and settings blur window's effect to 0
        blurEffect = blurView.effect
        blurView.isHidden = true
        blurView.effect = nil
        
        //rounding corners of embeded views
        descriptionView.layer.cornerRadius = 27
        dimensionsView.layer.cornerRadius = 27
        availabilityView.layer.cornerRadius = 27
        
        if let user = Auth.auth().currentUser{
            Database.database().reference().child("Providers").child(user.uid).child("personalInfo").observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let ratingString = String(describing: dictionary["rating"]!)
                    let roundedRating = (Double(ratingString)! * 100).rounded()/100
                    let ratingTemp = String(format: "%.2f", roundedRating)
                    // MEDIUM
                    let fontRating: UIFont? = UIFont(name: "Dosis-Medium", size:14)
                    let ratingAttString:NSMutableAttributedString = NSMutableAttributedString(string: ratingTemp, attributes: [.font: fontRating!])
                    self.ratingLabel.attributedText = ratingAttString
                    
                    let nameString = String(describing: dictionary["Name"]!)
                    let nameFont: UIFont? = UIFont(name: "Dosis-Bold", size:18)
                    let nameAttString:NSMutableAttributedString = NSMutableAttributedString(string: nameString, attributes: [.font: nameFont!])
                    self.nameLabel.attributedText = nameAttString
                    
                }
            })
        }
        
        //Hexagon SHape
        let lineWidth = CGFloat(7.0)
        let rect = CGRect(x: 0, y: 0.0, width: 90, height: 96)
        let sides = 6
        
        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 8.0, rotationOffset: CGFloat(.pi / 2.0))
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineCap = kCALineCapRound
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.white.cgColor
        
        _ = createImage(layer: borderLayer)
        
        
        
        profileImage.contentMode = .scaleAspectFill
        //        profileImage.layer.cornerRadius = 20
        profileImage.layer.masksToBounds = false
        profileImage.layer.mask = borderLayer
        profileImage.loadProfilePicture()
        // Do any additional setup after loading the view.
    }
    
    func animateInDimensions() {
        self.view.addSubview(dimensionsView)
        dimensionsView.center = self.view.center
        dimensionsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        dimensionsView.alpha = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.dimensionsView.alpha = 1
            self.dimensionsView.transform = CGAffineTransform.identity
            }
    }
    
    func animateOutDimensions(){
        UIView.animate(withDuration: 0.3, animations: {
            self.dimensionsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.dimensionsView.alpha = 0
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }) { (success:Bool) in
            self.dimensionsView.removeFromSuperview()
        }
    }
    
    func animateInDescriptions() {
        self.view.addSubview(descriptionView)
        descriptionView.center = self.view.center
        descriptionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        descriptionView.alpha = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.descriptionView.alpha = 1
            self.descriptionView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutDescriptions() {
        UIView.animate(withDuration: 0.3, animations: {
            self.descriptionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.descriptionView.alpha = 0
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }) { (success:Bool) in
            self.descriptionView.removeFromSuperview()
        }
    }
    
    func animateInAvailability(){
        self.view.addSubview(availabilityView)
        availabilityView.center = self.view.center
        availabilityView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        availabilityView.alpha = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.availabilityView.alpha = 1
            self.availabilityView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutAvailability(){
        UIView.animate(withDuration: 0.3, animations: {
            self.availabilityView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.availabilityView.alpha = 0
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }) { (success:Bool) in
            self.availabilityView.removeFromSuperview()
        }
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

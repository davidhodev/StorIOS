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


extension String{
    var digits: String{
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

class Dates{
    var day = [String]()
    var hour = [String]()
    init(day: [String], hour: [String]){
        self.day = day
        self.hour = hour
    }
}

class addListingViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    //photos variables
    @IBOutlet weak var storageImage: UIImageView!
    @IBOutlet weak var addPhoto: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    // dimensions variables, slider and their labels w values
    @IBOutlet var dimensionsView: UIView!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var widthSliderOutlet: UISlider!
    @IBOutlet weak var lengthSliderOutlet: UISlider!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var heightSliderOutlet: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    //widthxlengthxheight
    @IBOutlet weak var cubicFeetLabel: UILabel!
    //ft3 with superscript
    @IBOutlet weak var feetCubedLabel: UILabel!
    @IBOutlet weak var savedDimensionsLabel: UILabel!
    @IBOutlet weak var savedCubicFeetLabel: UILabel!
    @IBOutlet weak var dimensionsErrorLabel: UILabel!
    @IBOutlet weak var placeHolderDimensionsLabel: UILabel!
    
    //description variables
    @IBOutlet var descriptionView: UIView!
    @IBOutlet weak var userDescriptionText: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    let picker = UIPickerView()
    // 3 text views to take in the text from picker view
    
    //availability variables
    @IBOutlet var availabilityView: UIView!
    @IBOutlet weak var availabilityInfoLabel: UILabel!
    
    //blur effect and window
    @IBOutlet weak var blurView: UIVisualEffectView!
    var blurEffect: UIVisualEffect!
    
    // final add listing button, need to add checks for all filled out/parking spot
    @IBAction func addListingButton(_ sender: Any) {
        print("add Listing!")
    }
    //exit button for full page
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //takes you to dimensions pop up
    @IBAction func addDimensionsPressed(_ sender: UIButton) {
        animateInDimensions()
    }
    //save button for dimensions
    @IBAction func exitDimensions(_ sender: UIButton) {
        if (widthFeet != 0 && lengthFeet != 0 && heightFeet != 0){
            animateOutDimensions()
            var cubicFinalString = cubicFeetLabel.text
            cubicFinalString?.append(" ")
            cubicFinalString?.append(feetCubedLabel.text!)
            savedCubicFeetLabel.text = cubicFinalString
            savedCubicFeetLabel.isHidden = false
            var dimensionsFinalString = String(describing: widthFeet!)
            dimensionsFinalString += (" X ")
            dimensionsFinalString += String(describing: lengthFeet!)
            savedDimensionsLabel.text = dimensionsFinalString
            savedDimensionsLabel.isHidden = false
            placeHolderDimensionsLabel.isHidden = true
            dimensionsErrorLabel.isHidden = true
        }
        else if (widthFeet == 0 && lengthFeet == 0 && heightFeet == 0){
            animateOutDimensions()
        }
        else{
            dimensionsErrorLabel.isHidden = false
        }
    }
    
    //takes you to description pop up
    @IBAction func addDescriptionPressed(_ sender: UIButton) {
        animateInDescriptions()
    }
    // save button for descriptions
    @IBAction func exitDescription(_ sender: UIButton) {
        descriptionLabel.text = userDescriptionText.text
        animateOutDescriptions()
    }
    
    //takes you to availability pop up
    @IBAction func addAvailabilityPressed(_ sender: UIButton) {
        animateInAvailability()
    }
    //save button for availability
    @IBAction func exitAvailability(_ sender: UIButton) {
        animateOutAvailability()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //feet cubed label hidden
        feetCubedLabel.isHidden = true
        savedCubicFeetLabel.isHidden = true
        savedDimensionsLabel.isHidden = true
        dimensionsErrorLabel.isHidden = true
        let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
        let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
        
        let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: "ft3", attributes: [.font:font!])
        cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:2 ,length:1))
        self.feetCubedLabel.attributedText = cubicFeetAttString
        
        //recording blur effect and settings blur window's effect to 0
        blurEffect = blurView.effect
        blurView.isHidden = true
        blurView.effect = nil
        
        //rounding corners of embeded views
        descriptionView.layer.cornerRadius = 27
        dimensionsView.layer.cornerRadius = 27
        availabilityView.layer.cornerRadius = 27
        descriptionView.frame = subviewFrame
        dimensionsView.frame = subviewFrame2
        availabilityView.frame = subviewFrame
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
                    print("NAME ATT STRING: ", nameAttString)
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
    let subviewFrame = CGRect(x: 62.5, y: 92, width: 250, height: 300)
    let subviewFrame2 = CGRect(x: 62.5, y: 92, width: 250, height: 350)
    // animates in dimension pop up and adds blur
    func animateInDimensions() {
        self.view.addSubview(dimensionsView)
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
    // animates out dimension pop up and blur
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
    
    //parking switch
    @IBAction func parkingSwitch(_ sender: UISwitch) {
    }
    
    var widthFeet: Int? = 0
    var heightFeet: Int? = 0
    var lengthFeet: Int? = 0
    
    //dimensions variables code
    @IBAction func widthSliderAction(_ sender: UISlider) {
        var widthLabelText = "Width: "
        widthLabelText += String(describing: Int(sender.value))
        widthLabelText += " ft."
        widthLabel.text = widthLabelText
        widthFeet = Int(sender.value)
        cubicFeetLabel.text = (String(describing: Int(heightFeet! * lengthFeet! * widthFeet!)))
        feetCubedLabel.isHidden = false
    }

    @IBAction func lengthSliderAction(_ sender: UISlider) {
        var lengthLabelText = "Length: "
        lengthLabelText += String(describing: Int(sender.value))
        lengthLabelText += " ft."
        lengthLabel.text = lengthLabelText
        lengthFeet = Int(sender.value)
        cubicFeetLabel.text = (String(describing: Int(heightFeet! * lengthFeet! * widthFeet!)))
        feetCubedLabel.isHidden = false
    }

    @IBAction func heightSliderAction(_ sender: UISlider) {
        var heightLabelText = "Height: "
        heightLabelText += String(describing: Int(sender.value))
        heightLabelText += " ft."
        heightLabel.text = heightLabelText
        heightFeet = Int(sender.value)
        cubicFeetLabel.text = (String(describing: Int(heightFeet! * lengthFeet! * widthFeet!)))
        feetCubedLabel.isHidden = false
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

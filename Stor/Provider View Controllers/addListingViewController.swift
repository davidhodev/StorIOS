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
import FirebaseStorage
import Photos

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

class addListingViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, UITextViewDelegate {
    var uniqueStorageID = NSUUID().uuidString
    var newActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()

    @IBOutlet weak var profileImage: UIImageView!
    //photos variables

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
    @IBOutlet weak var addressLabel: UILabel!
    
    //description variables
    @IBOutlet var descriptionView: UIView!
    @IBOutlet weak var userDescriptionText: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    let picker = UIPickerView()
    // 3 text views to take in the text from picker view
    
    
    //blur effect and window
    @IBOutlet weak var blurView: UIVisualEffectView!
    var blurEffect: UIVisualEffect!

    @IBOutlet weak var exitDescription: UIButton!
    @IBAction func exitDescriptionButton(_ sender: Any) {
        animateOutDescriptions()
    }
    
    @IBOutlet weak var exitDimensions: UIButton!
    @IBAction func exitDimensionsButton(_ sender: Any) {
        animateOutDimensions()
    }
    
    
    // Add Images
    @IBOutlet weak var addImageScrollView: UIScrollView!
    var addImagesDictionary = ["2": UIImage(named: "Blank Photo")]
    var currentPage: Int?
    
    // final add listing button, need to add checks for all filled out/parking spot
    @IBAction func addListingButton(_ sender: Any) {
        // Show Pricing
        if cubicFeetLabel.text! == "" || savedDimensionsLabel.text! == "" || descriptionLabel.text! == "Tap the plus sign to create a custom description. Add up to 500 characters." || (addImagesDictionary.count == 0 && addImagesDictionary["2"]! == UIImage(named: "BlankPhoto")){
            let alert = UIAlertController(title: "Uh-oh", message: "Please fill out the entire page before publishing your listing", preferredStyle: .alert)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
            return
        }
        
        
        
        
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Providers").child(uid!).child("personalInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                print(snapshot)
                 if let dictionary = snapshot.value as? [String: Any]{
                    print(dictionary["backgroundCheck"])
                    if dictionary["backgroundCheck"] as? String == "pending"{
                        let alert = UIAlertController(title: "Uh-oh", message: "You have to wait for your background check to be completed before publishing your listing", preferredStyle: .alert)
                        self.present(alert, animated: true, completion:{
                            alert.view.superview?.isUserInteractionEnabled = true
                            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                        })
                    }
                    else{
                        let actionSheet = UIAlertController(title: "Are you sure you want to add this listing?", message: nil, preferredStyle: .actionSheet)
                        
                        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        let yes = UIAlertAction(title: "Yes", style: .default) { action in
                            self.createListing()
                        }
                        
                        actionSheet.addAction(yes)
                        actionSheet.addAction(cancel)
                        self.present(actionSheet, animated: true, completion: nil)
                        
                        
                    }
                }
                
                
            }
        })
        print("add Listing!")
    }
    
    func createListing(){
        let uid = Auth.auth().currentUser?.uid
        var finalPhotosDictionary = [String: Any]()
        
        for (index, feature) in addImagesDictionary{
            if feature != UIImage(named: "Blank Photo"){
                let imageUniqueID = NSUUID().uuidString
                print(imageUniqueID)
                let storageRef = Storage.storage().reference().child("ProviderStorageAddImages").child("\(imageUniqueID).jpeg")
                
                
                if let uploadData = UIImageJPEGRepresentation(feature!, 0.1){
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                        if (error != nil){
                            print(error)
                            return
                        }
                        storageRef.downloadURL(completion: { (updatedURL, error) in
                            if (error != nil){
                                print(error)
                                return
                            }
                            print("URL: ", updatedURL?.absoluteString)
                            var stringIndex = "photo"
                            stringIndex += String(describing: index)
                            finalPhotosDictionary[stringIndex] = updatedURL?.absoluteString
                            print("ADDED IMAGE", finalPhotosDictionary)
                            Database.database().reference().child("Providers").child(uid!).child("currentStorage").child(self.uniqueStorageID).child("Photos").updateChildValues(finalPhotosDictionary)
                        })
                    })
                }
            }
        }
        Database.database().reference().child("Providers").child(uid!).child("currentStorage").child(uniqueStorageID).updateChildValues(["Address": addressLabel.text!, "Height": heightFeet!, "Length": lengthFeet!, "Name": nameLabel.text!, "Price": 100000, "Subtitle": descriptionLabel.text!, "Title": "Title", "Width": widthFeet!, "status": "available", "providerStatus": "avaialable"])
        
        filterManager.shared.mapVC.fetchProviders()

        self.dismiss(animated: true, completion: nil)
        
        filterManager.shared.mapVC.reloadMap()
        //RELOAD TABLEVIEW
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
            cubicFinalString?.append("ft3")
            
            let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
            let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
            
            let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: cubicFinalString!, attributes: [.font:font!])
            cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:(cubicFinalString?.count)!-1,length:1))
            
            savedCubicFeetLabel.attributedText = cubicFeetAttString
            savedCubicFeetLabel.isHidden = false
            var dimensionsFinalString = String(describing: lengthFeet!)
            dimensionsFinalString += ("' x ")
            dimensionsFinalString += String(describing: widthFeet!)
            dimensionsFinalString += ("'")
            
            let dimensionsFont:UIFont? = UIFont(name: "Dosis-Bold", size:16)
            let dimensionsAttString:NSMutableAttributedString = NSMutableAttributedString(string: dimensionsFinalString, attributes: [.font: dimensionsFont!])
            
            savedDimensionsLabel.attributedText = dimensionsAttString
            savedDimensionsLabel.isHidden = false
            placeHolderDimensionsLabel.isHidden = true
            dimensionsErrorLabel.isHidden = true
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userDescriptionText!.layer.borderWidth = 0.75
        userDescriptionText!.layer.cornerRadius = 10
        userDescriptionText!.layer.borderColor = UIColor(red:0.58, green:0.41, blue:0.90, alpha:1.0).cgColor
        
        // Activity Indicator
        newActivityIndicator.center = self.view.center
        newActivityIndicator.hidesWhenStopped = true
        newActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(newActivityIndicator)
        
        newActivityIndicator.startAnimating()
        
        //feet cubed label hidden
        
        

        addImageScrollView.delegate = self
        self.addImageScrollView.isPagingEnabled = true
        self.addImageScrollView.showsHorizontalScrollIndicator = true
        self.addImageScrollView.showsVerticalScrollIndicator = false
        
        reloadAddImages()
        
        addImageScrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(choosePhoto)))

        
        
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
        descriptionView.frame = subviewFrame
        dimensionsView.frame = subviewFrame2
        dimensionsView.center.x = view.center.x
        descriptionView.center.x = view.center.x
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
                    
                    let addressString = String(describing: dictionary["permanentAddress"]!)
                    let addressAttString:NSMutableAttributedString = NSMutableAttributedString(string: addressString, attributes: [.font: fontRating!])
                    self.addressLabel.attributedText = addressAttString
                    self.newActivityIndicator.stopAnimating()
                    
                }
            })
        }
        
        //Hexagon SHape
        let lineWidth = CGFloat(7.0)
        let rect = CGRect(x: 0, y: 0.0, width: 50, height: 54)
        let sides = 6
        
        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 6.0, rotationOffset: CGFloat(.pi / 2.0))
        
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
    //descriptions
    let subviewFrame = CGRect(x: 62.5, y: 92, width: 312, height: 300) // 312 369
    //dimensions
    let subviewFrame2 = CGRect(x: 62.5, y: 92, width: 312, height: 360)
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
            self.exitDimensions.isHidden = false
            self.exitDescription.isHidden = true
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
        beginEdittingOutlet.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.descriptionView.alpha = 1
            self.descriptionView.transform = CGAffineTransform.identity
            self.exitDescription.isHidden = false
            self.exitDimensions.isHidden = true
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

    @IBOutlet weak var beginEdittingOutlet: UIButton!
    
    @IBAction func beginEditing(_ sender: UIButton) {
        userDescriptionText.becomeFirstResponder()
        beginEdittingOutlet.isHidden = true
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
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    // CHOOSING PHOTOS
    @objc func choosePhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var selectedImage: UIImage?
        if let edittedImage = info["UIImagePickerControllerEdittedImage"] as? UIImage {
            selectedImage = edittedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImageFinal = selectedImage{
            let currentPage = Int(self.addImageScrollView.contentOffset.x / self.addImageScrollView.frame.size.width)
            print("CURRENT PAGE", currentPage)
            addImagesDictionary[String(describing: currentPage)] = selectedImageFinal
            print("ADD IMAGE DICTIONARY", addImagesDictionary)
        }
        
        reloadAddImages()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print("1:", scrollView.contentOffset.x)
//        print("2:", scrollView.frame.size.width)
//        currentPage = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
//        featurePageControl.currentPage = Int(page)
//    }
    
    func reloadAddImages(){
        print("COUNT OF DICTIOANRY", addImagesDictionary.count)
        print("EDIT ADD IMAGES", addImagesDictionary)
        let sortedKeys = addImagesDictionary.keys.sorted()
        self.addImageScrollView.contentSize = CGSize(width: self.addImageScrollView.bounds.width * CGFloat(addImagesDictionary.count), height: 155)
        for (index, feature) in sortedKeys.enumerated(){
            DispatchQueue.main.async(execute: { () -> Void in
                let myImage = self.addImagesDictionary[feature]
                let myImageView:UIImageView = UIImageView()
                myImageView.frame.size.width = self.view.bounds.size.width
                myImageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                myImageView.image = myImage!
                myImageView.contentMode = .scaleAspectFill

                let xPosition = (self.addImageScrollView.frame.width) * CGFloat(index)
                myImageView.frame = CGRect(x: xPosition, y: 0, width: self.addImageScrollView.frame.width, height: self.addImageScrollView.frame.height)
                self.addImageScrollView.layer.cornerRadius = 8
                
                self.addImageScrollView.addSubview(myImageView)
            })
        }
    }
    
    

}

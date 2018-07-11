//
//  MenuViewController.swift
//  Stor
//
//  Created by Cole Feldman on 5/24/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage
import Firebase



class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // white hex group variables, y translation
    @IBOutlet weak var bottomWhiteHex: UIImageView!
    @IBOutlet weak var settingsButtonOutlet: UIButton!
    @IBOutlet weak var settingsLabelOutlet: UILabel!
    @IBOutlet weak var paymentLabelOutlet: UILabel!
    @IBOutlet weak var paymentButtonOutlet: UIButton!
    @IBOutlet weak var providerButtonOutlet: UIButton!
    @IBOutlet weak var providerLabelOutlet: UILabel!
    @IBOutlet weak var myListButtonOutlet: UIButton!
    @IBOutlet weak var myListLabelOutlet: UILabel!
    @IBOutlet weak var myStorageLabelOutlet: UILabel!
    @IBOutlet weak var myStorageButtonOutlet: UIButton!
    @IBOutlet weak var exitButtonOutlet: UIButton!
    @IBOutlet weak var helpButtonOutlet: UIButton!
    
    // blue hex group variables for x and y translation
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBOutlet weak var menuBlueHexOutlet: UIImageView!
    @IBOutlet weak var starOutlet: UIImageView!
    
    // fade animation variables
    @IBOutlet weak var sideWhiteHex: UIImageView!
    @IBOutlet weak var topLeftHex: UIImageView!
    @IBOutlet weak var topRightHex: UIImageView!
    @IBOutlet weak var legalButtonOutlet: UIButton!
    @IBOutlet weak var legalLabel: UILabel!
    
    @IBAction func exitButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.25 , delay: 0, options: .curveEaseIn, animations: {
            //white hex and attachments animations
            self.topRightHex.alpha = 0
            self.topLeftHex.alpha = 0
            self.legalButtonOutlet.alpha = 0
            self.legalLabel.alpha = 0
            self.sideWhiteHex.alpha = 0
        }) { (_) in
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.bottomWhiteHex.transform = CGAffineTransform(translationX: 0, y: 515)
                self.settingsLabelOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.settingsButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.paymentLabelOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.paymentButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.providerLabelOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.providerButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.myListLabelOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.myListButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.myStorageLabelOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.myStorageButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.exitButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                self.helpButtonOutlet.transform = CGAffineTransform(translationX: 0, y: 515)
                //blue hex animations
                self.menuBlueHexOutlet.transform = CGAffineTransform(translationX: 339, y: -363)
                self.profileImage.transform = CGAffineTransform(translationX: 339, y: -363)
                self.nameLabel.transform = CGAffineTransform(translationX: 339, y: -363)
                self.rating.transform = CGAffineTransform(translationX: 339, y: -363)
                self.starOutlet.transform = CGAffineTransform(translationX: 339, y: -363)
                
            })
                { (_) in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func menuHelpButton(_ sender: UIButton) {
        openUrl(urlStr: "https://www.mystorapp.com/contact-us-1/")
    }
    func openUrl(urlStr:String!) {
        
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    // loading animations
    @objc fileprivate func loadingAnimation() {
        print ("animating")
        UIView.animate(withDuration: 0.25 , delay: 0.3, options: .curveEaseOut, animations: {
            //white hex and attachments animations
            self.bottomWhiteHex.transform = CGAffineTransform(translationX: 0, y: -515)
            self.settingsLabelOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.settingsButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.paymentLabelOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.paymentButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.providerLabelOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.providerButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.myListLabelOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.myListButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.myStorageLabelOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.myStorageButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.exitButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            self.helpButtonOutlet.transform = CGAffineTransform(translationX: 0, y: -515)
            //blue hex animations
            self.menuBlueHexOutlet.transform = CGAffineTransform(translationX: -339, y: 363)
            self.profileImage.transform = CGAffineTransform(translationX: -339, y: 363)
            self.nameLabel.transform = CGAffineTransform(translationX: -339, y: 363)
            self.rating.transform = CGAffineTransform(translationX: -339, y: 363)
            self.starOutlet.transform = CGAffineTransform(translationX: -339, y: 363)
        }) { (_) in
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseOut, animations: {
                self.topRightHex.alpha = 1
                self.topLeftHex.alpha = 1
                self.legalButtonOutlet.alpha = 1
                self.legalLabel.alpha = 1
                self.sideWhiteHex.alpha = 1
                }
            )}
    }
    
    @IBAction func becomeProviderButton(_ sender: UIButton) {
        if let user = Auth.auth().currentUser{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let userReference = databaseReference.root.child("Providers").child((user.uid))
            
            userReference.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.exists() == true{
                    self.performSegue(withIdentifier: "toProviderMenu", sender: self)
                    
                }
                else{
                    self.performSegue(withIdentifier: "toSocialSecuritySegue", sender: self)
                }
            })
            { (error) in
                print(error)
            }
        }
        
    }
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let stackView = UIStackView(arrangedSubviews: [nameLabel])
//        stackView.axis = .vertical
//        view.addSubview(stackView)
        //prepping fade in
        legalLabel.alpha = 0
        topLeftHex.alpha = 0
        topRightHex.alpha = 0
        sideWhiteHex.alpha = 0
        legalButtonOutlet.alpha = 0
        print("Test1")
        self.nameLabel.text = globalVariablesViewController.username
        print("ralet sting", String(describing: globalVariablesViewController.ratingNumber))
        let outputRating2 = ((globalVariablesViewController.ratingNumber as! Double) * 100).rounded()/100
        self.rating.text = String(format: "%.2f",  outputRating2)
        
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
//        profileImage.layer.addSublayer(borderLayer)
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        
        profileImage.loadProfilePicture()
        //Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadingAnimation()
    }
    
    // Creating Hexagon Shape for Profile Picture
    
    // What happens when Image is Pressed
    @objc func handleSelectImageView(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Finished Picking Photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        if let edittedImage = info["UIImagePickerControllerEdittedImage"] as? UIImage {
            selectedImage = edittedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImageFinal = selectedImage{
            profileImage.image = selectedImageFinal
        }
        let imageUniqueID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("UserProfileImages").child("\(imageUniqueID).jpeg")
        
       
        if let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){

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
                    globalVariablesViewController.profilePicString = (updatedURL?.absoluteString)!
                    if let user = Auth.auth().currentUser{
                        let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                        let userReference = databaseReference.root.child("Users").child((user.uid))
                        print(userReference)
                        userReference.updateChildValues(["profilePicture": updatedURL?.absoluteString], withCompletionBlock: {(err, registerDataValues) in
                            if err != nil{
                                print(err)
                                return
                            }
                            print("Profile Pic Updated")
                            
                        })
                    }
                })
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Cancelled Picking Photo
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

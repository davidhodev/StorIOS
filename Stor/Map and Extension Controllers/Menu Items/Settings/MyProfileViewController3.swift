 //
//  MyProfileViewController3.swift
//  Stor
//
//  Created by Cole Feldman on 6/8/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MyProfileViewController3: UIViewController {
    var email: String?
    var phone: String?
    var password: String?
    var typeProvider: String?

    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var changePhoneButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet var myProfileView: UIView!
    
    @IBOutlet weak var facebookPopup: UIImageView!
    @IBOutlet weak var googlePopup: UIImageView!
    
    var iconClick : Bool!
    
    @objc fileprivate func infoButtonAnimation(){
        UIView.animate(withDuration: 0.3, animations: {
            self.informationButton.alpha = 1
            })
        }
    
    override func viewDidAppear(_ animated: Bool) {
        infoButtonAnimation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        myProfileView.addGestureRecognizer(swipeLeft)
        googlePopup.alpha = 0
        facebookPopup.alpha = 0
        googlePopup.isUserInteractionEnabled = true
        facebookPopup.isUserInteractionEnabled = true
        googlePopup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(googlePressed)))
        facebookPopup.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(facebookPressed)))
        
        googlePopup.alpha = 0
        if let user = Auth.auth().currentUser{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            databaseReference.root.child("Users").child(user.uid).observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: Any]{
                    self.phone = String(describing: dictionary["phone"]!)
                    self.email = String(describing: dictionary["email"]!)
                    print("PHONE 1", String(describing: dictionary["phone"]!))
                    print("PHONE 2", self.phone!)
                    self.phoneLabel.text = self.phone!
                    self.emailLabel.text = self.email!
                }
            })
        }
        if let user = Auth.auth().currentUser{
            print("PROVIDER ID", user.providerData[0].providerID)
            if user.providerData[0].providerID == "facebook.com"{
                typeProvider = "facebook"
            }
            else if user.providerData[0].providerID == "google.com"{
                typeProvider = "google"
            }
            else{
                typeProvider = "email"
            }
        }

        // phone long press
        iconClick = true
        let longPhonePressGestureRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.longPhonePress))
        longPhonePressGestureRecog.minimumPressDuration = 0.5
        changePhoneButton.addGestureRecognizer(longPhonePressGestureRecog)
        
        // email long press
        let longEmailPressGestureRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.longEmailPress))
        longEmailPressGestureRecog.minimumPressDuration = 0.5
        changeEmailButton.addGestureRecognizer(longEmailPressGestureRecog)
        
        // password long press
        let longPasswordPressGestureRecog = UILongPressGestureRecognizer(target: self, action: #selector(self.longPasswordPress))
        longPasswordPressGestureRecog.minimumPressDuration = 0.5
        changePasswordButton.addGestureRecognizer(longPasswordPressGestureRecog)
        
        self.nameLabel.text = globalVariablesViewController.username
        print("ralet sting", String(describing: globalVariablesViewController.ratingNumber))
        let outputRating2 = ((globalVariablesViewController.ratingNumber as! Double) * 100).rounded()/100
        self.ratingLabel.text = String(format: "%.2f",  outputRating2)
        
        
        //Hexagon SHape
        let lineWidth = CGFloat(7.0)
        let rect = CGRect(x: 0, y: 0.0, width: 70, height: 76)
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
//        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        
        profileImage.loadProfilePicture()
        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
    }
    @objc func backSwipe(){
        self.dismiss(animated: true, completion: nil)
    }
    
// brings to change phone page
    @objc func longPhonePress() {
        if let user = Auth.auth().currentUser{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let userReference = databaseReference.root.child("Providers").child((user.uid))
            let phoneReference = databaseReference.root.child("Users").child(user.uid)
            phoneReference.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let phoneString = String(describing: dictionary["phone"]!)
                    print("PHONE STRING === ", phoneString)
                    if  phoneString == "phoneVerify"{
                        self.performSegue(withIdentifier: "profileNoPhone", sender: self)
                    }
                    else{

                    }
                }
            })
        }
 
//        self.performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
    }
    
//    @IBAction func phoneDoneEditingButton(_ sender: UIButton) {
//        if (phoneTextField.text?.isPhoneNumber)!{
//            phoneLabel.text = phoneTextField.text
//            phoneLabel.isHidden = false
//            phoneTextField.isHidden = true
//            phoneTextField.isEnabled = false
//
//            phoneTextField.resignFirstResponder()
//
//            if let user = Auth.auth().currentUser{
//                let registerDataValues = ["phone": phoneTextField.text ] as [String : Any]
//
//                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
//                let userReference = databaseReference.root.child("Users").child((user.uid))
//
//                userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
//                    if err != nil{
//                        print(err)
//                        return
//                    }
//                })
//
//                databaseReference.child("Providers").child((user.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
//                    if snapshot.exists(){
//                        databaseReference.root.child("Providers").child(user.uid).child("personalInfo").updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
//                            if err != nil{
//                                print(err)
//                                return
//                            }
//                        })
//                    }
//
//                })
//            }
//        }
//    }
    
    @objc func longEmailPress() {
        if typeProvider == "facebook"{
            UIView.animate(withDuration: 0.3, animations: {
                self.facebookPopup.alpha = 1
            })
        }
            
        
        else if typeProvider == "google"{
            UIView.animate(withDuration: 0.3, animations: {
                self.googlePopup.alpha = 1
            })
        }
        else{
            self.performSegue(withIdentifier: "toChangeEmail", sender: self)
        }
    }
    
//    @IBAction func emailDoneEditing(_ sender: UIButton) {
//        if (emailTextField.text?.contains("@") == true){
//            emailLabel.text = emailTextField.text
//            emailLabel.isHidden = false
//            emailTextField.isHidden = true
//            emailTextField.isEnabled = false
//            emailDoneButton.isHidden = true
//            errorLabel.isHidden = true
//            emailTextField.resignFirstResponder()
//
//
//            if let user = Auth.auth().currentUser{
//                let registerDataValues = ["email": emailTextField.text ] as [String : Any]
//
//                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
//                let userReference = databaseReference.root.child("Users").child((user.uid))
//
//                databaseReference.child("Users").child((user.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
//                    userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
//                        if err != nil{
//                            print(err)
//                            return
//                        }
//                    })
//                })
//            }
//        }
//        else{
//            errorLabel.isHidden = false
//            errorLabel.text = "Invalid Email. Please check your submission."
//        }
//    }
    // password press and done button
    @objc func longPasswordPress() {
        if typeProvider == "facebook"{
            UIView.animate(withDuration: 0.3, animations: {
                self.facebookPopup.alpha = 1
            })
        }
        else if typeProvider == "google"{
            UIView.animate(withDuration: 0.3, animations: {
                self.googlePopup.alpha = 1
            })
        }
        else{
             self.performSegue(withIdentifier: "toChangePassword", sender: self)
        }
       
    }
    
//    @IBAction func passwordDoneEditing(_ sender: UIButton) {
//        if (passwordTextField.text == confirmPasswordTextField.text){
//            if ((passwordTextField.text?.count)! < 6){
//                errorLabel.text = "Password contains too few characters."
//                errorLabel.isHidden = false
//            }
//            else {
//                passwordLabel.isHidden = false
//                passwordTextField.isHidden = true
//                confirmPasswordTextField.isHidden = true
//                passwordTextField.isEnabled = false
//                passwordDoneButton.isHidden = true
//                errorLabel.isHidden = true
//                revealTextOutlet.isHidden = true
//                passwordTextField.resignFirstResponder()
//                if let user = Auth.auth().currentUser{
//                    let registerDataValues = ["password": passwordTextField.text ] as [String : Any]
//
//                    let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
//                    let userReference = databaseReference.root.child("Users").child((user.uid))
//
//                    databaseReference.child("Users").child((user.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
//                        userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
//                            if err != nil{
//                                print(err)
//                                return
//                            }
//                        })
//                    })
//                }
//            }
//        }
//        else{
//            errorLabel.text = "Password entries do not match."
//            errorLabel.isHidden = false
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //change text from secure to not secure
    
    @IBAction func BackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func informationButtonPressed(_ sender: Any) {
        [UIButton .animate(withDuration: 0.3, animations: {
            self.informationButton.alpha = 0
        })]
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MyProfileViewController3.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func facebookPressed(){
        UIView.animate(withDuration: 0.3, animations: {
            self.facebookPopup.alpha = 0
        })
    }
    
    @objc func googlePressed(){
        UIView.animate(withDuration: 0.3, animations: {
            self.googlePopup.alpha = 0
        })
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

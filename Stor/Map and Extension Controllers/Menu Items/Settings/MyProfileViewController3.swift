//
//  MyProfileViewController3.swift
//  Stor
//
//  Created by Cole Feldman on 6/8/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit


class MyProfileViewController3: UIViewController {

    @IBOutlet weak var informationButton: UIButton!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var phoneDoneButton: UIButton!
    @IBOutlet weak var changePhoneButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordDoneButton: UIButton!
    @IBOutlet weak var emailDoneButton: UIButton!
    @IBOutlet weak var changeEmailButton: UIButton!
    @IBOutlet weak var changePasswordButton: UIButton!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var revealTextOutlet: UIButton!
    var iconClick : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
        //setting phone texts and buttons
        phoneTextField.isEnabled = false
        phoneTextField.isHidden = true
        phoneDoneButton.isHidden = true
        phoneTextField.text = phoneLabel.text
        errorLabel.isHidden = true
        
        //setting email texts and buttons
        emailTextField.isEnabled = false
        emailTextField.isHidden = true
        emailDoneButton.isHidden = true
        emailTextField.text = emailLabel.text
        
        //setting password texts and buttons
        passwordTextField.isEnabled = false
        passwordTextField.isHidden = true
        confirmPasswordTextField.isEnabled = false
        confirmPasswordTextField.isHidden = true
        passwordDoneButton.isHidden = true
        passwordTextField.text = ""
        revealTextOutlet.isHidden = true
        
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
    }
// hides label, brings up text and done button, enables text to be edited
    @objc func longPhonePress() {
        phoneTextField.isHidden = false
        phoneTextField.isEnabled = true
        phoneLabel.isHidden = true
        phoneDoneButton.isHidden = false
    }
    
    @IBAction func phoneDoneEditingButton(_ sender: UIButton) {
        if (phoneTextField.text?.isPhoneNumber)!{
            phoneLabel.text = phoneTextField.text
            phoneLabel.isHidden = false
            phoneTextField.isHidden = true
            phoneTextField.isEnabled = false
            phoneDoneButton.isHidden = true
            errorLabel.isHidden = true
        }
        else{
            errorLabel.isHidden = false
            errorLabel.text = "Invalid Phone Number. Please use the format (111)-111-1111."
        }
    }
    
    @objc func longEmailPress() {
        emailTextField.isHidden = false
        emailTextField.isEnabled = true
        emailLabel.isHidden = true
        emailDoneButton.isHidden = false
    }
    
    @IBAction func emailDoneEditing(_ sender: UIButton) {
        if (emailTextField.text?.contains("@") == true){
            emailLabel.text = emailTextField.text
            emailLabel.isHidden = false
            emailTextField.isHidden = true
            emailTextField.isEnabled = false
            emailDoneButton.isHidden = true
            errorLabel.isHidden = true
        }
        else{
            errorLabel.isHidden = false
            errorLabel.text = "Invalid Email. Please check your submission."
        }
    }
    // password press and done button
    @objc func longPasswordPress() {
        confirmPasswordTextField.text = ""
        passwordTextField.isHidden = false
        passwordTextField.isEnabled = true
        confirmPasswordTextField.isHidden = false
        confirmPasswordTextField.isEnabled = true
        passwordLabel.isHidden = true
        passwordDoneButton.isHidden = false
        revealTextOutlet.isHidden = false
    }
    
    @IBAction func passwordDoneEditing(_ sender: UIButton) {
        if (passwordTextField.text == confirmPasswordTextField.text){
            if ((passwordTextField.text?.count)! < 6){
                errorLabel.text = "Password contains too few characters."
                errorLabel.isHidden = false
            }
            else {
                passwordLabel.isHidden = false
                passwordTextField.isHidden = true
                confirmPasswordTextField.isHidden = true
                passwordTextField.isEnabled = false
                passwordDoneButton.isHidden = true
                errorLabel.isHidden = true
            }
        }
        else{
            errorLabel.text = "Password entries do not match."
            errorLabel.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //change text from secure to not secure
    @IBAction func revealTextButtonPressed(_ sender: UIButton) {
        if(iconClick == true) {
            passwordTextField.isSecureTextEntry = false
            confirmPasswordTextField.isSecureTextEntry = false
            iconClick = false
        } else {
            passwordTextField.isSecureTextEntry = true
            confirmPasswordTextField.isSecureTextEntry = true
            iconClick = true
        }
    }
    
    @IBAction func BackButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func informationButtonPressed(_ sender: Any) {
        [UIButton .animate(withDuration: 0.3, animations: {
            self.informationButton.alpha = 0
        })]
    }
}

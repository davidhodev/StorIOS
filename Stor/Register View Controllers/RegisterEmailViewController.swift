//
//  RegisterEmailViewController.swift
//  Stor
//
//  Created by David Ho on 5/21/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

class RegisterEmailViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameRegisterText: UITextField!
    @IBOutlet weak var emailRegisterText: UITextField!
    @IBOutlet weak var passwordRegisterText: UITextField!
    @IBOutlet weak var phoneRegisterText: UITextField!
    @IBOutlet weak var confirmPasswordRegisterText: UITextField!
    @IBOutlet weak var phoneVerificationText: UITextField!
    @IBOutlet weak var showTextOutlet: UIButton!
    var iconClick = true
    
    @IBOutlet var registerView: UIView!
    @IBOutlet weak var checkBox: VKCheckbox!
    @IBOutlet weak var agreeToTerms: UILabel!
    
    //oops mislabeled the first one
    @IBOutlet weak var termsButton: UIButton!
    @IBOutlet weak var andLabel: UILabel!
    @IBOutlet weak var privacyPolicyButton: UIButton!
    
    
    
    
    @IBOutlet weak var greyDash1: UIImageView!
    @IBOutlet weak var Dash2: UIImageView!
    @IBOutlet weak var Dash3: UIImageView!
    @IBOutlet weak var Dash4: UIImageView!
    
    
    var registerSteps = 0
    var agreedToTerms = false
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    //line under email address
    @IBOutlet weak var line1: UIImageView!
    //line under phone number
    @IBOutlet weak var line2: UIImageView!
    //line under password
    @IBOutlet weak var line3: UIImageView!
    //Main Picture
    @IBOutlet weak var mainImage: UIImageView!
    //Password Pciture
    @IBOutlet weak var passwordImage: UIImageView!
    //Confirm PasswordPicture
    @IBOutlet weak var confirmPasswordImage: UIImageView!
    
    
    //Question Label
    @IBOutlet weak var questionLabel: UILabel!
    
    
    
    // Next Button
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBAction func nextButton(_ sender: Any) {
        nextButtonPressed()
    }
    func nextButtonPressed(){
        if registerSteps == 0{
            // fade out text field, icon, line, translate to right at the same time
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.nameRegisterText.alpha = 0
                self.mainImage.alpha = 0
                self.questionLabel.alpha = 0
                //may change this
                self.line1.alpha = 0
                self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                self.nameRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.emailRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
            }) { (_) in
                // change icons and text
                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                    self.mainImage.image =  UIImage.init(named: "Combined Shape1")
                    self.questionLabel.text = "What's your email?"
                    self.greyDash1.image = UIImage(named: "Blue Dash")
                }) { (_) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.emailRegisterText.alpha = 1
                        self.questionLabel.alpha = 1
                        self.mainImage.alpha = 1
                        self.line1.alpha = 1
                        self.emailRegisterText.transform = self.emailRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.nameRegisterText.transform = self.emailRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                        self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                    })
                }
            }
            emailRegisterText.becomeFirstResponder()
            registerSteps += 1
            // Animation to bring in Email
        }
        else if registerSteps == 1{
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            Auth.auth().fetchProviders(forEmail: emailRegisterText.text!, completion: { (stringArray, error) in
                if error != nil{
                    print(error)
                    self.line1.image = UIImage.init(named: "Line 2Red")
                    self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "E-mail is not in proper format", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                    self.emailRegisterText.text = ""
                    self.mainImage.image = UIImage.init(named: "Mail Icon Red")
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                }
                else{
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                    if stringArray == nil{
                        UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                            self.emailRegisterText.alpha = 0
                            self.mainImage.alpha = 0
                            self.questionLabel.alpha = 0
                            //may change this
                            self.line1.alpha = 0
                            self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.emailRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.passwordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.confirmPasswordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.confirmPasswordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.passwordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.line2.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.line3.transform = CGAffineTransform(translationX: 375, y: 0)
                            self.showTextOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
                        }) { (_) in
                            // change icons and text
                            UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                                self.questionLabel.text = "What's your password?"
                                self.passwordImage.image = UIImage(named: "Combined Shape2-1")
                                self.confirmPasswordImage.image = UIImage(named: "Confirm Password Icon")
                                self.line1.image = UIImage(named: "Line 2")
                                self.Dash2.image = UIImage(named: "Blue Dash")
                            }) { (_) in
                                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                                    self.questionLabel.alpha = 1
                                    self.line2.alpha = 1
                                    self.line3.alpha = 1
                                    self.passwordRegisterText.alpha = 1
                                    self.confirmPasswordRegisterText.alpha = 1
                                    self.passwordImage.alpha = 1
                                    self.confirmPasswordImage.alpha = 1
                                    self.showTextOutlet.alpha = 1
                                    self.emailRegisterText.transform = self.emailRegisterText.transform.translatedBy(x: -375, y: 0)
                                    self.passwordRegisterText.transform = self.passwordRegisterText.transform.translatedBy(x: -375, y: 0)
                                    self.confirmPasswordRegisterText.transform = self.confirmPasswordRegisterText.transform.translatedBy(x: -375, y: 0)
                                    self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                                    self.confirmPasswordImage.transform = self.confirmPasswordImage.transform.translatedBy(x: -375, y: 0)
                                    self.passwordImage.transform = self.passwordImage.transform.translatedBy(x: -375, y: 0)
                                    self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                                    self.line2.transform = self.line2.transform.translatedBy(x: -375, y: 0)
                                    self.line3.transform = self.line3.transform.translatedBy(x: -375, y: 0)
                                    self.showTextOutlet.transform = self.showTextOutlet.transform.translatedBy(x: -375, y: 0)
                                })
                            }
                        }
                        
                        self.passwordRegisterText.becomeFirstResponder()
                        self.registerSteps += 1
                    }
                    else{
                        self.line1.image = UIImage.init(named: "Line 2Red")
                        self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "Acount already exists with that email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailRegisterText.text = ""
                        self.mainImage.image = UIImage.init(named: "Mail Icon Red")
                        print("USER EXISTS WITH THAT EMAIL")
                    }
                }
            })
        }
        else if registerSteps == 2{
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            
            
            if passwordRegisterText.text! != confirmPasswordRegisterText.text!{
                self.confirmPasswordRegisterText.attributedPlaceholder = NSAttributedString(string: "Your passwords don't match!", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                self.confirmPasswordRegisterText.text = ""
                self.confirmPasswordImage.image = UIImage.init(named: "Red Lock")
                self.line3.image = UIImage.init(named: "Line 2Red")
                print("Passwords don't match!")
            }
            else if (passwordRegisterText.text?.count)! < 6{
                self.passwordRegisterText.attributedPlaceholder = NSAttributedString(string: "Must be at least 6 characters", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                self.confirmPasswordRegisterText.attributedPlaceholder = NSAttributedString(string: "Must be at least 6 characters", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                self.passwordRegisterText.text = ""
                self.confirmPasswordRegisterText.text = ""
                self.passwordImage.image = UIImage.init(named: "Red Lock")
                self.confirmPasswordImage.image = UIImage.init(named: "Confirm Password Icon Red")
                self.line2.image = UIImage.init(named: "Line 2Red")
                self.line3.image = UIImage.init(named: "Line 2Red")
                
                print ("Password must at least be 6 characters")
            }
            else if passwordRegisterText.text?.rangeOfCharacter(from: characterset.inverted) == nil{
                self.passwordRegisterText.attributedPlaceholder = NSAttributedString(string: "Must have 1 special character", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                self.confirmPasswordRegisterText.attributedPlaceholder = NSAttributedString(string: "Must have 1 special character", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                self.passwordRegisterText.text = ""
                self.confirmPasswordRegisterText.text = ""
                self.passwordImage.image = UIImage.init(named: "Red Lock")
                self.confirmPasswordImage.image = UIImage.init(named: "Red Lock")
                self.line2.image = UIImage.init(named: "Line 2Red")
                self.line3.image = UIImage.init(named: "Line 2Red")
                
                print("String has no Special Characters")
            }
            else{
                UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                    self.passwordRegisterText.alpha = 0
                    self.confirmPasswordRegisterText.alpha = 0
                    self.confirmPasswordImage.alpha = 0
                    self.passwordImage.alpha = 0
                    self.questionLabel.alpha = 0
                    self.line2.alpha = 0
                    self.line3.alpha = 0
                    self.showTextOutlet.alpha = 0
                    self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.line2.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.line3.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.passwordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.confirmPasswordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.phoneRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.confirmPasswordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.passwordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.showTextOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
                }) { (_) in
                    // change icons and text
                    UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                        self.questionLabel.text = "What's your phone number?"
                        self.mainImage.image =  UIImage.init(named: "Phone Icon")
                        self.Dash3.image = UIImage(named: "Blue Dash")
                    }) { (_) in
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            self.questionLabel.alpha = 1
                            self.line1.alpha = 1
                            self.mainImage.alpha = 1
                            self.phoneRegisterText.alpha = 1
                            self.phoneRegisterText.transform = self.phoneRegisterText.transform.translatedBy(x: -375, y: 0)
                            self.passwordRegisterText.transform = self.passwordRegisterText.transform.translatedBy(x: -375, y: 0)
                            self.confirmPasswordRegisterText.transform = self.confirmPasswordRegisterText.transform.translatedBy(x: -375, y: 0)
                            self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                            self.confirmPasswordImage.transform = self.confirmPasswordImage.transform.translatedBy(x: -375, y: 0)
                            self.passwordImage.transform = self.passwordImage.transform.translatedBy(x: -375, y: 0)
                            self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                            self.line2.transform = self.line2.transform.translatedBy(x: -375, y: 0)
                            self.line3.transform = self.line3.transform.translatedBy(x: -375, y: 0)
                            self.showTextOutlet.transform = self.showTextOutlet.transform.translatedBy(x: -375, y: 0)
                        })
                    }
                }
                self.passwordRegisterText.resignFirstResponder()
                phoneRegisterText.becomeFirstResponder()
                self.registerSteps += 1
            }
        }
        else if registerSteps == 3{
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            var inputPhone = "+1"
            inputPhone += phoneRegisterText.text!
            PhoneAuthProvider.provider().verifyPhoneNumber(inputPhone, uiDelegate: nil) { (verificationID, error) in
                if error != nil{
                    print(error)
                    //Phone wrong
                    self.line1.image = UIImage.init(named: "Line 2Red")
                    self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Enter a valid number", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                    self.phoneRegisterText.text = ""
                    self.mainImage.image = UIImage(named: "Phone Icon Red")
                    self.activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    return
                }
                self.activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                    self.nextButtonOutlet.alpha = 0
                    self.phoneRegisterText.alpha = 0
                    self.line1.alpha = 0
                    self.mainImage.alpha = 0
                    self.questionLabel.alpha = 0
                    self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.phoneRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.phoneVerificationText.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.checkBox.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.agreeToTerms.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.andLabel.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.termsButton.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.privacyPolicyButton.transform = CGAffineTransform(translationX: 375, y: 0)
                }) { (_) in
                    // change icons and text
                    UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                        self.questionLabel.text = "Enter the verification code."
                        self.mainImage.image =  UIImage.init(named: "Text Confirm Icon")
                        self.Dash4.image = UIImage(named: "Blue Dash")
                        self.line1.image = UIImage(named: "Line 2")
                        self.checkBox.borderColor = UIColor.init(red:0.16, green: 0.15, blue: 0.35, alpha: 1.0)
                        self.nextButtonOutlet.setImage(<#T##image: UIImage?##UIImage?#>, for: .normal)
                    }) { (_) in
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            //terms and policy things
                            self.agreeToTerms.alpha = 1
                            self.andLabel.alpha = 1
                            self.termsButton.alpha = 1
                            self.privacyPolicyButton.alpha = 1
                            self.checkBox.alpha = 1
                            self.nextButtonOutlet.alpha = 1
                            self.questionLabel.alpha = 1
                            self.line1.alpha = 1
                            self.mainImage.alpha = 1
                            self.phoneVerificationText.alpha = 1
                            self.phoneRegisterText.transform = self.phoneRegisterText.transform.translatedBy(x: -375, y: 0)
                            self.phoneVerificationText.transform = self.phoneVerificationText.transform.translatedBy(x: -375, y: 0)
                            self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                            self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                            self.checkBox.transform = self.checkBox.transform.translatedBy(x: -375, y: 0)
                            self.agreeToTerms.transform = self.agreeToTerms.transform.translatedBy(x: -375, y: 0)
                            self.termsButton.transform = self.termsButton.transform.translatedBy(x: -375, y: 0)
                            self.andLabel.transform = self.andLabel.transform.translatedBy(x: -375, y: 0)
                            self.privacyPolicyButton.transform = self.privacyPolicyButton.transform.translatedBy(x: -375, y: 0)
                        })
                    }
                }
                self.phoneRegisterText.resignFirstResponder()
                self.phoneVerificationText.becomeFirstResponder()
                self.registerSteps += 1
            }
            
            
        }
        else{
            
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
            if agreedToTerms == false{
                checkBox.borderColor = UIColor.red
                activityIndicator.stopAnimating()
                UIApplication.shared.endIgnoringInteractionEvents()
            } 
            else{
                let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: phoneVerificationText.text!)
                
                print("Credential", credential)
                print("VERIFICATION ID", UserDefaults.standard.string(forKey: "authVerificationID")!)
//                PhoneAuthProvider.verifyPhoneNumber(<#T##PhoneAuthProvider#>)
                Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                    if let error = error {
                        self.line1.image = UIImage.init(named: "Line 2Red")
                        self.phoneVerificationText.attributedPlaceholder = NSAttributedString(string: "The verification code is incorrect", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.phoneVerificationText.text = ""
                        self.mainImage.image = UIImage.init(named: "Text Confirm Icon Red")
                        self.line1.image = UIImage.init(named: "Line 2Red")
                        self.activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                        print(error)
                        return
                    }
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                        if let error = error {
                            print(error)
                        } else {
                            
                            print(" Account Deleted")
                            
                            guard let nameVerify = self.nameRegisterText.text else {return}
                            guard let emailVerify = self.emailRegisterText.text else {return}
                            guard let passwordVerify = self.passwordRegisterText.text else {return}
                            guard let phoneVerify = self.phoneRegisterText.text else {return}
                            
                            let defaultProfilePictureURL = "https://firebasestorage.googleapis.com/v0/b/stor-database.appspot.com/o/Group%202v2.jpeg?alt=media&token=4b1c267b-3b5d-4ad0-b79a-6f149ffa155e"
                            // Creates User from Firebase
                            Auth.auth().createUser(withEmail: emailVerify, password: passwordVerify){ user,error in
                                if (error == nil && user != nil){
                                    let registerDataValues = ["name": nameVerify, "email": emailVerify, "password": passwordVerify, "phone":phoneVerify, "profilePicture": defaultProfilePictureURL, "rating": 5, "numberOfRatings": 1, "deviceToken": AppDelegate.DEVICEID] as [String : Any]
                                    
                                    let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                                    let userReference = databaseReference.child("Users").child((user?.uid)!)
                                    userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                                        if err != nil{
                                            print(err)
                                            return
                                        }
                                        print("User successfully saved to FIREBASE!")
                                        self.activityIndicator.stopAnimating()
                                        UIApplication.shared.endIgnoringInteractionEvents()
                                        
                                    })
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBAction func backButton(_ sender: Any) {
        
        if registerSteps == 0{
            self.navigationController?.popToRootViewController(animated: true)
        }
        else if registerSteps == 1{
            //animate out email, animate in name
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.emailRegisterText.alpha = 0
                self.mainImage.alpha = 0
                self.questionLabel.alpha = 0
                //may change this
                self.line1.alpha = 0
                self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                self.nameRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.emailRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)

            }) { (_) in
                // change icons and text
                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                    self.mainImage.image =  UIImage.init(named: "nameCardIcon")
                    self.questionLabel.text = "What's your name?"
                    //reset if there is error
                    self.line1.image = UIImage(named: "Line 2")
                    self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.greyDash1.image = UIImage(named: "Grey Dash")
                }) { (_) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.nameRegisterText.alpha = 1
                        self.questionLabel.alpha = 1
                        self.mainImage.alpha = 1
                        self.line1.alpha = 1
                        self.emailRegisterText.transform = self.emailRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.nameRegisterText.transform = self.nameRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                        self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                    })
                }
            }
            self.emailRegisterText.resignFirstResponder()
            self.nameRegisterText.becomeFirstResponder()
            registerSteps -= 1
        }
        else if registerSteps == 2{
            //animate out passwords, animate in email
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.emailRegisterText.alpha = 0
                self.mainImage.alpha = 0
                self.questionLabel.alpha = 0
                self.line2.alpha = 0
                self.line3.alpha = 0
                self.passwordRegisterText.alpha = 0
                self.confirmPasswordRegisterText.alpha = 0
                self.passwordImage.alpha = 0
                self.showTextOutlet.alpha = 0
                self.confirmPasswordImage.alpha = 0
                //may change this
                self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                self.emailRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.passwordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.confirmPasswordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.confirmPasswordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.passwordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.showTextOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
            }) { (_) in
                // change icons and text
                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                    self.questionLabel.text = "What's your email?"
                    //reset if errors
                    self.mainImage.image = UIImage(named: "Combined Shape1")
                    self.confirmPasswordImage.image = UIImage(named: "Confirm Password Icon")
                    self.passwordImage.image = UIImage(named: "Combined Shape2-1")
                    self.line1.image = UIImage(named: "Line 2")
                    self.line2.image = UIImage(named: "Line 2")
                    self.line3.image = UIImage(named: "Line 2")
                    self.passwordRegisterText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.confirmPasswordRegisterText.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.Dash2.image = UIImage(named: "Grey Dash")
                }) { (_) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.emailRegisterText.alpha = 1
                        self.mainImage.alpha = 1
                        self.questionLabel.alpha = 1
                        self.line1.alpha = 1
                        self.emailRegisterText.transform = self.emailRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.nameRegisterText.transform = self.emailRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                        self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                        self.showTextOutlet.transform = self.showTextOutlet.transform.translatedBy(x: -375, y: 0)
                    })
                }
            }
            emailRegisterText.becomeFirstResponder()
            registerSteps -= 1
        }
        else if registerSteps == 3{
            //animate out phone, animate in passwords
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.phoneRegisterText.alpha = 0
                self.questionLabel.alpha = 0
                self.line1.alpha = 0
                self.mainImage.alpha = 0
                self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                self.line2.transform = CGAffineTransform(translationX: 375, y: 0)
                self.line3.transform = CGAffineTransform(translationX: 375, y: 0)
                self.passwordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.confirmPasswordRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.phoneRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.confirmPasswordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.passwordImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.showTextOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
            }) { (_) in
                // change icons and text
                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                    self.questionLabel.text = "What's your password?"
                    //reset if errors
                    self.mainImage.image = UIImage(named: "Phone Icon")
                    self.confirmPasswordImage.image = UIImage(named: "Confirm Password Icon")
                    self.passwordImage.image = UIImage(named: "Combined Shape2-1")
                    self.line1.image = UIImage(named: "Line 2")
                    self.line2.image = UIImage(named: "Line 2")
                    self.line3.image = UIImage(named: "Line 2")
                    self.passwordRegisterText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.confirmPasswordRegisterText.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.Dash3.image = UIImage(named: "Grey Dash")
                }) { (_) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.questionLabel.alpha = 1
                        self.line2.alpha = 1
                        self.line3.alpha = 1
                        self.passwordRegisterText.alpha = 1
                        self.confirmPasswordRegisterText.alpha = 1
                        self.passwordImage.alpha = 1
                        self.confirmPasswordImage.alpha = 1
                        self.showTextOutlet.alpha = 1
                        self.phoneRegisterText.transform = self.phoneRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.passwordRegisterText.transform = self.passwordRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.confirmPasswordRegisterText.transform = self.confirmPasswordRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                        self.confirmPasswordImage.transform = self.confirmPasswordImage.transform.translatedBy(x: -375, y: 0)
                        self.passwordImage.transform = self.passwordImage.transform.translatedBy(x: -375, y: 0)
                        self.showTextOutlet.transform = self.showTextOutlet.transform.translatedBy(x: -375, y: 0)
                        self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                        self.line2.transform = self.line2.transform.translatedBy(x: -375, y: 0)
                        self.line3.transform = self.line3.transform.translatedBy(x: -375, y: 0)
                    })
                }
            }
            registerSteps -= 1
        }
        else{
            //animate out phone confirmation, animate in phone
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.phoneVerificationText.alpha = 0
                self.line1.alpha = 0
                self.mainImage.alpha = 0
                self.questionLabel.alpha = 0
                self.checkBox.alpha = 0
                self.agreeToTerms.alpha = 0
                self.nextButtonOutlet.alpha = 0
                self.termsButton.alpha = 0
                self.andLabel.alpha = 0
                self.privacyPolicyButton.alpha = 0
                self.line1.transform = CGAffineTransform(translationX: 375, y: 0)
                self.phoneRegisterText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.phoneVerificationText.transform = CGAffineTransform(translationX: 375, y: 0)
                self.mainImage.transform = CGAffineTransform(translationX: 375, y: 0)
                self.checkBox.transform = CGAffineTransform(translationX: 375, y: 0)
                self.agreeToTerms.transform = CGAffineTransform(translationX: 375, y: 0)
                self.termsButton.transform = CGAffineTransform(translationX: 375, y: 0)
                self.andLabel.transform = CGAffineTransform(translationX: 375, y: 0)
                self.privacyPolicyButton.transform = CGAffineTransform(translationX: 375, y: 0)
            }) { (_) in
                // change icons and text
                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                    self.questionLabel.text = "What's your phone number?"
                    self.mainImage.image =  UIImage.init(named: "Phone Icon")
                    //reset for errors
                    self.line1.image = UIImage(named: "Line 2")
                    self.phoneVerificationText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)])
                    self.Dash4.image = UIImage(named: "Grey Dash")
                    self.nextButtonOutlet.setImage(#imageLiteral(resourceName: "Button Arrow ->"), for: .normal)
                }) { (_) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.questionLabel.alpha = 1
                        self.line1.alpha = 1
                        self.mainImage.alpha = 1
                        self.phoneRegisterText.alpha = 1
                        self.nextButtonOutlet.alpha = 1
                        self.phoneRegisterText.transform = self.phoneRegisterText.transform.translatedBy(x: -375, y: 0)
                        self.phoneVerificationText.transform = self.phoneVerificationText.transform.translatedBy(x: -375, y: 0)
                        self.mainImage.transform = self.mainImage.transform.translatedBy(x: -375, y: 0)
                        self.line1.transform = self.line1.transform.translatedBy(x: -375, y: 0)
                        self.checkBox.transform = self.checkBox.transform.translatedBy(x: -375, y: 0)
                        self.agreeToTerms.transform = self.agreeToTerms.transform.translatedBy(x: -375, y: 0)
                        self.andLabel.transform = self.andLabel.transform.translatedBy(x: -375, y: 0)
                        self.privacyPolicyButton.transform = self.privacyPolicyButton.transform.translatedBy(x: -375, y: 0)
                        self.termsButton.transform = self.termsButton.transform.translatedBy(x: -375, y: 0)
                        
                    })
                }
            }
            registerSteps -= 1
        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        registerView.addGestureRecognizer(swipeLeft)
        
        nameRegisterText.delegate = self
        emailRegisterText.delegate = self
        phoneRegisterText.delegate = self
        passwordRegisterText.delegate = self
        
        // Setting Alphas to 0
        emailRegisterText.alpha = 0
        passwordRegisterText.alpha = 0
        confirmPasswordRegisterText.alpha = 0
        phoneRegisterText.alpha = 0
        phoneVerificationText.alpha = 0
        line2.alpha = 0
        line3.alpha = 0
        passwordImage.alpha = 0
        confirmPasswordImage.alpha = 0
        showTextOutlet.alpha = 0
        checkBox.alpha = 0
        agreeToTerms.alpha = 0
        termsButton.alpha = 0
        andLabel.alpha = 0
        privacyPolicyButton.alpha = 0
        
        questionLabel.text = "What's your name?"
        
        nameRegisterText.becomeFirstResponder()
        
        
        checkBox.line = .thin
        checkBox.borderColor = UIColor.init(red:0.16, green:0.15, blue:0.35, alpha:1.0)
        checkBox.color = UIColor.init(red:0.27, green:0.47, blue:0.91, alpha:1.0)
        checkBox.borderWidth = 1
    
//         Simple checkbox callback
        checkBox.checkboxValueChangedBlock = {
            isOn in
            if isOn{
                self.agreedToTerms = true
            }
            else{
                self.agreedToTerms = false
            }
        }
        
        
        line1.image = UIImage.init(named: "Line 2")
        line2.image = UIImage.init(named: "Line 2")
        line3.image = UIImage.init(named: "Line 2")
        mainImage.image = UIImage.init(named: "nameCardIcon")
//        phonePicture.image = UIImage.init(named: "Phone Icon")
        passwordImage.image = UIImage.init(named: "Combined Shape2")
        
//        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func backSwipe(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    

    // Register Function
    func register(){
        guard let nameVerify = nameRegisterText.text else {return}
        guard let emailVerify = emailRegisterText.text else {return}
        guard let passwordVerify = passwordRegisterText.text else {return}
        guard let phoneVerify = phoneRegisterText.text else {return}
        
        if (phoneRegisterText.text?.isPhoneNumber)!{
            print("Valid Phone number")
        }
        else{
            self.line2.image = UIImage.init(named: "Line 2Red")
            self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Phone number is not valid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.phoneRegisterText.text = ""
//            self.phonePicture.image = UIImage.init(named: "Phone Icon Red")
            return
        }
        
        
//        PhoneAuthProvider.provider().verifyPhoneNumber(phoneVerify, uiDelegate: nil) { (verificationID, error) in
//            if ((error) != nil){
//                print(error)
//                return
//            }
//            print(verificationID)
//            UserDefaults.standard.set(verificationID, forKey: "firebase_verification")
//            UserDefaults.standard.synchronize()
//        }
        print("TESTING IF IT WORKS")
        
        let defaultProfilePictureURL = "https://firebasestorage.googleapis.com/v0/b/stor-database.appspot.com/o/Group%202v2.jpeg?alt=media&token=4b1c267b-3b5d-4ad0-b79a-6f149ffa155e"
        // Creates User from Firebase
        Auth.auth().createUser(withEmail: emailVerify, password: passwordVerify){ user,error in
            if (error == nil && user != nil){
                let registerDataValues = ["name": nameVerify, "email": emailVerify, "password": passwordVerify, "phone":phoneVerify, "profilePicture": defaultProfilePictureURL, "rating": 5, "numberOfRatings": 1, "deviceToken": AppDelegate.DEVICEID] as [String : Any]
                
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.child("Users").child((user?.uid)!)
                userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                    if err != nil{
                        print(err)
                        return
                    }
                    print("User successfully saved to FIREBASE!")
                    
                })
                self.navigationController?.popToRootViewController(animated: true)
            }
        //Error Handling
            if (error != nil){
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                    case .invalidEmail: // E-mail is not in email format
                        print("Invalid email")
                        self.line1.image = UIImage.init(named: "Line 2Red")
                        self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "E-mail is not in proper format", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailRegisterText.text = ""
//                        self.emailPicture.image = UIImage.init(named: "Mail Icon Red")
                    case .weakPassword: //Weak Password, must be at least 6 characters long
                        print("Weak Password")
                        self.line3.image = UIImage.init(named: "Line 2Red")
                        self.passwordRegisterText.attributedPlaceholder = NSAttributedString(string: "Must be at least 6 characters", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.passwordRegisterText.text = ""
//                        self.passwordPicture.image = UIImage.init(named: "Red Lock")
                    case .invalidPhoneNumber: // Phone number is not a valid phone number
                        print("Incorrect phone number")
                        self.line2.image = UIImage.init(named: "Line 2Red")
                        self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Phone number is not valid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.phoneRegisterText.text = ""
//                        self.phonePicture.image = UIImage.init(named: "Phone Icon Red")
                    case .emailAlreadyInUse: // Account Already exists with that email
                        print("account alrady exists")
                        self.line1.image = UIImage.init(named: "Line 2Red")
                        self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "Acount already exists with that email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailRegisterText.text = ""
//                        self.emailPicture.image = UIImage.init(named: "Mail Icon Red")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
            }
        }
    }
    
//    func hideKeyboardWhenTappedAround() {
//        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterEmailViewController.dismissKeyboard))
//        tap.cancelsTouchesInView = false
//        view.addGestureRecognizer(tap)
//    }
//
//    @objc func dismissKeyboard() {
//        view.endEditing(true)
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (passwordRegisterText.isFirstResponder){
            passwordRegisterText.resignFirstResponder()
            confirmPasswordRegisterText.becomeFirstResponder()
        }
        else{
            nextButtonPressed()
        }
        return true
    }
    
    @IBAction func showTextPressed(_ sender: Any) {
        if(iconClick == false) {
            confirmPasswordRegisterText.isSecureTextEntry = false
            passwordRegisterText.isSecureTextEntry = false
            showTextOutlet.setImage(#imageLiteral(resourceName: "crossed out eye"), for: .normal)
            iconClick = true
        }
        else{
            confirmPasswordRegisterText.isSecureTextEntry = true
            passwordRegisterText.isSecureTextEntry = true
            showTextOutlet.setImage(#imageLiteral(resourceName: "Combined Shape3-1"), for: .normal)
            iconClick = false
        }
    }
}
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


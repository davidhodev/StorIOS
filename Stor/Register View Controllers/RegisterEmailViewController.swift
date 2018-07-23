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
    
    
    @IBOutlet var registerView: UIView!

    
    var registerSteps = 0
    
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
//        registerSteps += 1
        if registerSteps == 0{
            self.nameRegisterText.alpha = 0
            self.emailRegisterText.alpha = 1
            self.mainImage.image =  UIImage.init(named: "Combined Shape1")
            self.questionLabel.text = "What's your email?"
            registerSteps += 1
            // Animation to bring in Email
        }
        else if registerSteps == 1{
            Auth.auth().fetchProviders(forEmail: emailRegisterText.text!, completion: { (stringArray, error) in
                if error != nil{
                    print(error)
                    self.line1.image = UIImage.init(named: "Line 2Red")
                    self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "E-mail is not in proper format", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                    self.emailRegisterText.text = ""
                    self.mainImage.image = UIImage.init(named: "Mail Icon Red")
                }
                else{
                    if stringArray == nil{
                        self.emailRegisterText.alpha = 0
                        self.passwordRegisterText.alpha = 1
                        self.confirmPasswordRegisterText.alpha = 1
                        self.mainImage.alpha = 0
                        self.passwordImage.alpha = 1
                        self.confirmPasswordImage.alpha = 1
                        
                        self.line1.alpha = 0
                        self.line2.alpha = 1
                        self.line3.alpha = 1
                        
                        self.questionLabel.text = "What's your password?"
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
                self.confirmPasswordImage.image = UIImage.init(named: "Red Lock")
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
                self.phoneRegisterText.alpha = 1
                self.passwordRegisterText.alpha = 0
                self.confirmPasswordRegisterText.alpha = 0
                self.mainImage.image =  UIImage.init(named: "Phone Icon")
                self.mainImage.alpha = 1
                self.passwordImage.alpha = 0
                self.confirmPasswordImage.alpha = 0
                
                self.line1.alpha = 1
                self.line2.alpha = 0
                self.line3.alpha = 0
                
                self.questionLabel.text = "What's your Phone Number"
                self.registerSteps += 1
            }
        }
        else if registerSteps == 3{
            
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneRegisterText.text!, uiDelegate: nil) { (verificationID, error) in
                if error != nil{
                    print(error)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.phoneRegisterText.alpha = 0
                self.phoneVerificationText.alpha = 1
                self.mainImage.image =  UIImage.init(named: "Phone Icon")
                self.questionLabel.text = "Verification Stuff"
                self.phoneRegisterText.resignFirstResponder()
                self.phoneVerificationText.becomeFirstResponder()
                self.registerSteps += 1
            }
            
            
        }
        else{
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: phoneVerificationText.text!)
            
            print("Credential", credential)
            print("VERIFICATION ID", UserDefaults.standard.string(forKey: "authVerificationID")!)
            
            Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
                if let error = error {
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
                                    
                                })
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
                    }
                }
            }
            
        }
        
//
//        if registerSteps == 5{
//            self.register()
//        }
        
        
    }
    
    @IBOutlet weak var backButtonOutlet: UIButton!
    @IBAction func backButton(_ sender: Any) {
        
        if registerSteps == 0{
            self.navigationController?.popToRootViewController(animated: true)
        }
//        registerSteps -= 1
        
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
        questionLabel.text = "What's your name?"
        
        
        
        
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
        if textField == nameRegisterText{
            nameRegisterText.resignFirstResponder()
            emailRegisterText.becomeFirstResponder()
        }
        else if textField == emailRegisterText{
            emailRegisterText.resignFirstResponder()
            phoneRegisterText.becomeFirstResponder()
        }
        else if textField == phoneRegisterText{
            phoneRegisterText.resignFirstResponder()
            passwordRegisterText.becomeFirstResponder()
        }
        else{
            register()
        }
        return true
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


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

class RegisterEmailViewController: UIViewController {

    @IBOutlet weak var nameRegisterText: UITextField!
    @IBOutlet weak var emailRegisterText: UITextField!
    @IBOutlet weak var passwordRegisterText: UITextField!
    @IBOutlet weak var phoneRegisterText: UITextField!
    
    //line under email address
    @IBOutlet weak var lineEmail: UIImageView!
    //line under phone number
    @IBOutlet weak var linePhone: UIImageView!
    //line under password
    @IBOutlet weak var linePassword: UIImageView!
    //email picture
    @IBOutlet weak var emailPicture: UIImageView!
    //phone picture
    @IBOutlet weak var phonePicture: UIImageView!
    //password picture
    @IBOutlet weak var passwordPicture: UIImageView!
    
    // Button for Register
    @IBAction func registerButton(_ sender: Any) {
        self.register()
    }
    // takes you back to the front page
    @IBAction func registrationBackButton(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineEmail.image = UIImage.init(named: "Line 2")
        linePhone.image = UIImage.init(named: "Line 2")
        linePassword.image = UIImage.init(named: "Line 2")
        emailPicture.image = UIImage.init(named: "Combined Shape1")
        phonePicture.image = UIImage.init(named: "Phone Icon")
        passwordPicture.image = UIImage.init(named: "Combined Shape2")
        
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            self.linePhone.image = UIImage.init(named: "Line 2Red")
            self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Phone number is not valid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.phoneRegisterText.text = ""
            self.phonePicture.image = UIImage.init(named: "Phone Icon Red")
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
                        self.lineEmail.image = UIImage.init(named: "Line 2Red")
                        self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "E-mail is not in proper format", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailRegisterText.text = ""
                        self.emailPicture.image = UIImage.init(named: "Mail Icon Red")
                    case .weakPassword: //Weak Password, must be at least 6 characters long
                        print("Weak Password")
                        self.linePassword.image = UIImage.init(named: "Line 2Red")
                        self.passwordRegisterText.attributedPlaceholder = NSAttributedString(string: "Must be at least 6 characters", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.passwordRegisterText.text = ""
                        self.passwordPicture.image = UIImage.init(named: "Red Lock")
                    case .invalidPhoneNumber: // Phone number is not a valid phone number
                        print("Incorrect phone number")
                        self.linePhone.image = UIImage.init(named: "Line 2Red")
                        self.phoneRegisterText.attributedPlaceholder = NSAttributedString(string: "Phone number is not valid", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.phoneRegisterText.text = ""
                        self.phonePicture.image = UIImage.init(named: "Phone Icon Red")
                    case .emailAlreadyInUse: // Account Already exists with that email
                        print("account alrady exists")
                        self.lineEmail.image = UIImage.init(named: "Line 2Red")
                        self.emailRegisterText.attributedPlaceholder = NSAttributedString(string: "Acount already exists with that email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailRegisterText.text = ""
                        self.emailPicture.image = UIImage.init(named: "Mail Icon Red")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterEmailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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


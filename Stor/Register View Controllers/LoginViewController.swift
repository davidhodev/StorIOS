//
//  LoginViewController.swift
//  Stor
//
//  Created by David Ho on 5/21/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    //instantiate password line
    @IBOutlet weak var line2Image: UIImageView!
    //instantiate email line
    @IBOutlet weak var line1Image: UIImageView!
    // instantiate eye button paramter
    var iconClick : Bool!
    // instantiate letter image
    @IBOutlet weak var letterImage: UIImageView!
    // instantiate lock image
    @IBOutlet weak var lockImage: UIImageView!
    
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    //Takes you to create Account
    @IBAction func homeButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    // button function to switch security of text
    @IBAction func revealText(_ sender: UIButton) {
        if(iconClick == true) {
            passwordText.isSecureTextEntry = false
            iconClick = false
        } else {
            passwordText.isSecureTextEntry = true
            iconClick = true
        }
    }
    
    // Action when Login Button Pressed
    @IBAction func loginButton(_ sender: Any) {
        self.login()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        iconClick = true
        line1Image.image = UIImage.init(named: "Line 2")
        line2Image.image = UIImage.init(named: "Line 2")
        letterImage.image = UIImage.init(named: "Combined Shape1")
        lockImage.image = UIImage.init(named: "Combined Shape2")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Making a login function
    func login(){
        
        //Activity Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!){
            user, error in
            if (error != nil){
                // Error Handling
                if let errCode = AuthErrorCode(rawValue: error!._code) {
                    
                    switch errCode {
                    case .userNotFound:
                        print("No Email Found")
                        // switches email bar to red
                        self.emailText.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        // removes text
                        self.emailText.text = ""
                        self.passwordText.text = ""
                        // sets bar and icon to red
                        self.line1Image.image = UIImage.init(named: "Line 2Red")
                        self.letterImage.image = UIImage.init(named: "Mail Icon Red")
                        // sets other bars and icons to original
                        self.passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.44, alpha: 0.56)])
                        self.line2Image.image = UIImage.init(named: "Line 2")
                        self.lockImage.image = UIImage.init(named: "Combined Shape2")
                    case .invalidEmail:
                        // switches placeholder to red
                        print("Invalid email")
                        self.emailText.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        // removes text
                        self.emailText.text = ""
                        self.passwordText.text = ""
                        // sets placeholder, bar, and icon to red
                        self.line1Image.image = UIImage.init(named: "Line 2Red")
                        self.letterImage.image = UIImage.init(named: "Mail Icon Red")
                        // sets other bars and icons to original
                        self.passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.44, alpha: 0.56)])
                        self.line2Image.image = UIImage.init(named: "Line 2")
                        self.lockImage.image = UIImage.init(named: "Combined Shape2")
                    case .wrongPassword:
                        print("Incorrect password")
                        // sets placeholder red
                        self.passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        //removes text
                        self.emailText.text = ""
                        self.passwordText.text = ""
                        // sets bars and icons to red
                        self.line2Image.image = UIImage.init(named: "Line 2Red")
                        self.lockImage.image = UIImage.init(named: "Red Lock")
                        // reverts other bar and icon
                        self.emailText.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(white: 0.44, alpha: 0.56)])
                        self.line1Image.image = UIImage.init(named: "Line 2")
                        self.letterImage.image = UIImage.init(named: "Combined Shape1")
                    default:
                        print("Create User Error: \(error)")
                    }
                }
            }
            // Correct Password
            else{
                self.activityIndicator.stopAnimating()
                print("Successfully logged in")
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let goToMapFromLogin:MapViewController = storyboard.instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
                self.navigationController?.pushViewController(goToMapFromLogin, animated: true)

            }
            self.activityIndicator.stopAnimating()
        }
    }


}

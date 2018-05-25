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
    //change color animation function

    
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
                         self.emailText.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailText.text = ""
                        self.passwordText.text = ""
                        self.line1Image.image = UIImage.init(named: "Line 2Red")
                    case .invalidEmail:
                        print("Invalid email")
                        self.emailText.attributedPlaceholder = NSAttributedString(string: "Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailText.text = ""
                        self.passwordText.text = ""
                        self.line1Image.image = UIImage.init(named: "Line 2Red")
                    case .wrongPassword:
                        print("Incorrect password")
                        self.passwordText.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.emailText.text = ""
                        self.passwordText.text = ""
                        self.line2Image.image = UIImage.init(named: "Line 2Red")
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

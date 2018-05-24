//
//  LoginViewController.swift
//  Stor
//
//  Created by David Ho on 5/21/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth

extension UIImageView {
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}

class LoginViewController: UIViewController {
    
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
                        self.emailText.backgroundColor = UIColor.red // RED BACKGROUND COLOR
                        self.emailText.text = ""
                        self.passwordText.text = ""
                    case .invalidEmail:
                        print("Invalid email")
                        self.emailText.backgroundColor = UIColor.red // RED BACKGROUND COLOR
                        self.emailText.text = ""
                        self.passwordText.text = ""
                    case .wrongPassword:
                        print("Incorrect password")
                        self.passwordText.backgroundColor = UIColor.red // RED BACKGROUND COLOR
                        self.emailText.text = ""
                        self.passwordText.text = ""
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

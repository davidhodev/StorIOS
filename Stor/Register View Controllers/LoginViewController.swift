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
    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    
    //Takes you to create Account
    @IBAction func homeButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // Action when Login Button Pressed
    @IBAction func loginButton(_ sender: Any) {
        self.login()
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //Making a login function
    func login(){
        print ("=========test=========")
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
                print("Successfully logged in")
                let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let goToMapFromLogin:MapViewController = storyboard.instantiateViewController(withIdentifier:"MapViewController") as! MapViewController
                self.navigationController?.pushViewController(goToMapFromLogin, animated: true)

            }
        }
    }


}
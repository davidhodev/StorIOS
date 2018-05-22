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
    
    //Action when Back Button Pressed
    @IBAction func backButtonPressed(_ sender: UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let backButtonPressed:StartupViewController = storyboard.instantiateViewController(withIdentifier:"StartupViewController") as! StartupViewController
        self.present(backButtonPressed, animated: true, completion: nil)
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
                self.dismiss(animated: true, completion: nil)
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

}

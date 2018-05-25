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


class RegisterEmailViewController: UIViewController {

    @IBOutlet weak var nameRegisterText: UITextField!
    @IBOutlet weak var emailRegisterText: UITextField!
    @IBOutlet weak var passwordRegisterText: UITextField!
    @IBOutlet weak var phoneRegisterText: UITextField!
    
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
        
        
        // Creates User from Firebase
        Auth.auth().createUser(withEmail: emailVerify, password: passwordVerify){ user,error in
            if (error == nil && user != nil){
                let registerDataValues = ["name": nameVerify, "email": emailVerify, "password": passwordVerify, "phone":phoneVerify]
                
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
                        self.emailRegisterText.backgroundColor = UIColor.red
                        
                    case .weakPassword: //Weak Password, must be at least 6 characters long
                        print("Weak Password")
                        self.passwordRegisterText.backgroundColor =  UIColor.red
                        
                    case .invalidPhoneNumber: // Phone number is not a valid phone number
                        print("Incorrect password")
                        self.passwordRegisterText.backgroundColor = UIColor.red
                        
                    case .emailAlreadyInUse: // Account Already exists with that email
                        print("account alrady exists")
                        self.emailRegisterText.backgroundColor = UIColor.red
                        
                    default:
                        print("Create User Error: \(error)")
                    }
                }
            }
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


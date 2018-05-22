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
        var saveData = true
        Auth.auth().createUser(withEmail: emailRegisterText.text!, password: passwordRegisterText.text!, completion:{
            user,error in
            print(error)
            
            //Error Handling
            if let errCode = AuthErrorCode(rawValue: error!._code) {
                
                switch errCode {
                case .invalidEmail:
                    print("Invalid email")
                    saveData = false
                case .invalidPhoneNumber:
                    print("Incorrect password")
                    saveData = false
                case .accountExistsWithDifferentCredential:
                    print("account alrady exists")
                    saveData = false
                default:
                    print("Create User Error: \(error)")
                }
            }
                // Correct Password
            else{
                print("Successfully registered")
            }
        })
        
        print (saveData)
        if (saveData == true){
            //Other Fields for Database in Registration
            let registerDataValues = ["name": nameRegisterText.text, "email": emailRegisterText.text, "password": passwordRegisterText.text, "phone":phoneRegisterText.text]
            
            
            
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let userReference = databaseReference.child("Users").child(nameRegisterText.text!)
            userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                if err != nil{
                    print(err)
                    return
                }
                 print("User successfully saved to FIREBASE!")
            })
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

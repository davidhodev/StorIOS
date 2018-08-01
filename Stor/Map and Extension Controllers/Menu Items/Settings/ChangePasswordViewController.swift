//
//  ChangePasswordViewController.swift
//  Stor
//
//  Created by Cole Feldman on 7/26/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class ChangePasswordViewController: UIViewController {
    @IBOutlet weak var oldPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    var passwordCheck = false
    
    @IBAction func submitAction(_ sender: Any) {
        // First Submit checking old password
        if passwordCheck == false{
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Providers").child((user.uid))
                databaseReference.root.child("Users").child(user.uid).observe(.value, with: { (snapshot) in
                    print(snapshot)
                    if let dictionary = snapshot.value as? [String: Any]{
                        let checkPasswordString = String(describing: dictionary["password"]!)
                        if checkPasswordString == self.oldPassword.text!{
                            self.passwordCheck = true
                            // Animate other text Fields
                        }
                    }
                })
            }
        }
        else{
            let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            if newPassword.text! != confirmPassword.text!{
                print("Passwords don't match")
                // PASSWORDS DON'T MATCH
            }
            else if newPassword.text!.count < 6{
                print("Password must be at least 6 characters!")
                // Must at least be 6 characters
            }
            else if newPassword.text?.rangeOfCharacter(from: characterset.inverted) == nil{
                print("Must have at least 1 special character")
                // Must at least have 1 special character
            }
            else{
                //It works!
                if let user = Auth.auth().currentUser{
                    let registerDataValues = ["password": newPassword.text ] as [String : Any]
                    let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                    let userReference = databaseReference.root.child("Users").child((user.uid))
                    user.updatePassword(to: newPassword.text!, completion: { (error) in
                        if error != nil{
                            print(error)
                            // Do stuff to turn red / make error changes
                        }
                        else{
                            userReference.updateChildValues(registerDataValues, withCompletionBlock: { (error, registerDataValues) in
                                if error != nil{
                                    print(error)
                                    return
                                    //ERROR CHANGING CHILD VALUE PASSWORD IN DATABASE
                                }
                            })
                        }
                    })
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        
        // Do any additional setup after loading the view.
    }

    
    @IBAction func backButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangePasswordViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

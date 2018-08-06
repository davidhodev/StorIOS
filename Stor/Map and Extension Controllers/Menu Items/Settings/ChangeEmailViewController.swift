//
//  ChangeEmailViewController.swift
//  Stor
//
//  Created by Cole Feldman on 7/26/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class ChangeEmailViewController: UIViewController {
    var oldEmailChecked = false
    

    @IBOutlet weak var oldEmail: UITextField!
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButtonPressed(_ sender: Any) {
        if oldEmailChecked == false{
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                databaseReference.root.child("Users").child(user.uid).observe(.value, with: { (snapshot) in
                    print(snapshot)
                    if let dictionary = snapshot.value as? [String: Any]{
                        let oldEmailString = String(describing: dictionary["email"]!)
                        if oldEmailString == self.oldEmail.text!{
                            self.oldEmailChecked = true
                            // Animate other text Fields
                        }
                    }
                })
            }
        }
        else{
            if let user = Auth.auth().currentUser{
                let registerDataValues = ["email": newEmail.text ] as [String : Any]
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((user.uid))
                
                user.updateEmail(to: newEmail.text!, completion: { (error) in
                    if error != nil{
                        print(error)
                        // Do stuff to turn red / make error changes
                    }
                    else{
                        userReference.updateChildValues(registerDataValues, withCompletionBlock: { (error, registerDataValues) in
                            if error != nil{
                                print(error)
                                return
                                //ERROR CHANGING CHILD VALUE EMAIL IN DATABASE
                            }
                        })
                    }
                })
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
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChangeEmailViewController.dismissKeyboard))
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

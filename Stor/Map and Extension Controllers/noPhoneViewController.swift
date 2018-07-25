//
//  noPhoneViewController.swift
//  Stor
//
//  Created by David Ho on 7/25/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class noPhoneViewController: UIViewController {

    @IBOutlet weak var exitButton: UIButton!
    @IBAction func exitButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneVerificationText: UITextField!
    var phoneEntered = false
    
    
    @IBAction func doneButtonPressend(_ sender: Any) {
        if phoneEntered == false{
            var inputPhone = "+1"
            inputPhone += phoneField.text!
            PhoneAuthProvider.provider().verifyPhoneNumber(inputPhone, uiDelegate: nil) { (verificationID, error) in
                if error != nil{
                    print(error)
                    //Phone wrong
                    print(error)
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                self.phoneEntered = true
            }
        }
        else{
        
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: phoneVerificationText.text!)
            
            print("Credential", credential)
            print("VERIFICATION ID", UserDefaults.standard.string(forKey: "authVerificationID")!)
            
            if let user = Auth.auth().currentUser{
                user.linkAndRetrieveData(with: credential, completion: { (authResult, error) in
                    if let error = error {
                        self.phoneVerificationText.text = ""
                        print(error)
                        return
                    }
                    print("Phone Added")
                    let registerDataValues = ["phone": self.phoneField.text ] as [String : Any]
                    
                    let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                    let userReference = databaseReference.root.child("Users").child((user.uid))
                        
                    userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                        if err != nil{
                            print(err)
                            return
                        }
                    })
                })
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginViewController.dismissKeyboard))
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

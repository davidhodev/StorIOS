//
//  changePhoneViewController.swift
//  Stor
//
//  Created by David Ho on 7/30/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


class changePhoneViewController: UIViewController {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var verificationField: UITextField!
    
    
    var verificationSent = false
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if verificationSent == false{
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
                self.verificationSent = true
            }
        }
        else{
            let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: verificationField.text!)
            
            print("Credential", credential)
            print("VERIFICATION ID", UserDefaults.standard.string(forKey: "authVerificationID")!)
            
            if let user = Auth.auth().currentUser{
                user.updatePhoneNumber(credential, completion: { (error) in
                    if error != nil{
                        print (error)
                        // Yikes something went wrong
                    }
                    else{
                        let registerDataValues = ["phone": self.phoneField.text ] as [String : Any]
                        
                        let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                        let userReference = databaseReference.root.child("Users").child((user.uid))
                        
                        userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                            if err != nil{
                                print(err)
                                return
                            }
                            else{
                                print("IT WORKED")
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changePhoneViewController.dismissKeyboard))
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

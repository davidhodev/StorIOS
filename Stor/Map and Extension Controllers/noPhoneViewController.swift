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
    
    @IBOutlet weak var lineOutlet: UIImageView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var textConfirmIcon: UIImageView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var phoneVerificationText: UITextField!
    var phoneEntered = false
    
    
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        var inputPhone = "+1"
        inputPhone += phoneField.text!
        PhoneAuthProvider.provider().verifyPhoneNumber(inputPhone, uiDelegate: nil) { (verificationID, error) in
            if error != nil{
                print(error)
                //Phone wrong
                self.lineOutlet.image = UIImage(named: "Line 2Red")
                self.phoneIcon.image = UIImage(named: "Phone Icon Red")
                self.phoneField.attributedPlaceholder = NSAttributedString(string: "Invalid number entered", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                self.phoneField.text = ""
                return
                return
            }
            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                self.lineOutlet.alpha = 0
                self.phoneIcon.alpha = 0
                self.phoneField.alpha = 0
                self.nextButtonOutlet.alpha = 0
                self.lineOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
                self.phoneField.transform = CGAffineTransform(translationX: 375, y: 0)
                self.phoneIcon.transform = CGAffineTransform(translationX: 375, y: 0)
                self.textConfirmIcon.transform = CGAffineTransform(translationX: 375, y: 0)
                self.phoneVerificationText.transform = CGAffineTransform(translationX: 375, y: 0)
            }) { (_) in
                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                    // change icons and text
                    self.nextButtonOutlet.isEnabled = false
                    self.doneButton.isUserInteractionEnabled = true
                }) { (_) in
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                        self.lineOutlet.alpha = 1
                        self.phoneVerificationText.alpha = 1
                        self.textConfirmIcon.alpha = 1
                        self.doneButton.alpha = 1
                        self.lineOutlet.transform = self.lineOutlet.transform.translatedBy(x: -375, y: 0)
                        self.phoneVerificationText.transform = self.phoneVerificationText.transform.translatedBy(x: -375, y: 0)
                        self.textConfirmIcon.transform = self.textConfirmIcon.transform.translatedBy(x: -375, y: 0)
                    })
                }
            }
            UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
            self.phoneEntered = true
        }
    }
    
    @IBAction func doneButtonPressend(_ sender: Any) {
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: phoneVerificationText.text!)
        
        print("Credential", credential)
        print("VERIFICATION ID", UserDefaults.standard.string(forKey: "authVerificationID")!)
        
        if let user = Auth.auth().currentUser{
            user.linkAndRetrieveData(with: credential, completion: { (authResult, error) in
                if let error = error {
                    self.phoneVerificationText.text = ""
                    self.lineOutlet.image = UIImage(named: "Line 2Red")
                    self.textConfirmIcon.image = UIImage(named: "Text Confirm Icon Red")
                    self.phoneVerificationText.attributedPlaceholder = NSAttributedString(string: "Wrong passcode entered", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
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
                        let alert = UIAlertController(title: "Uh-oh", message: "Please try again. Servers may be busy", preferredStyle: .alert)
                        self.present(alert, animated: true, completion:{
                            alert.view.superview?.isUserInteractionEnabled = true
                            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                        })
                        return
                    }
                    else{
                        self.dismiss(animated: true, completion: nil)
                    }
                })
            })
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textConfirmIcon.alpha = 0
        phoneVerificationText.alpha = 0
        doneButton.isEnabled = false
        doneButton.alpha = 0
        self.lineOutlet.image = UIImage(named: "Line 2")
        self.textConfirmIcon.image = UIImage(named: "Text Confirm Icon")
        self.phoneIcon.image = UIImage(named: "Phone Icon")
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

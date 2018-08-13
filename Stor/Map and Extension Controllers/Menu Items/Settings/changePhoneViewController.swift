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
    @IBOutlet weak var phoneVerificationIcon: UIImageView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var lineOutlet: UIImageView!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    
    
    var verificationSent = false
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        print("TEST12345")
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: UserDefaults.standard.string(forKey: "authVerificationID")!, verificationCode: verificationField.text!)
        
        print("Credential", credential)
        print("VERIFICATION ID", UserDefaults.standard.string(forKey: "authVerificationID")!)
        
        if let user = Auth.auth().currentUser{
            user.updatePhoneNumber(credential, completion: { (error) in
                if error != nil{
                    print (error)
                    // Yikes something went wrong, wrong passcode
                    self.lineOutlet.image = UIImage(named: "Line 2Red")
                    self.phoneVerificationIcon.image = UIImage(named: "Text Confirm Icon Red")
                    self.verificationField.attributedPlaceholder = NSAttributedString(string: "Wrong passcode entered", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                    self.verificationField.text = ""
                    
                }
                else{
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
                            print("IT WORKED")
                            //need to change the my profile display
                            self.dismiss(animated: true, completion: nil)
                        }
                    })
                }
            })
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        if verificationSent == false{
            var inputPhone = "+1"
            inputPhone += phoneField.text!
            PhoneAuthProvider.provider().verifyPhoneNumber(inputPhone, uiDelegate: nil) { (verificationID, error) in
                guard let errorCode = AuthErrorCode(rawValue: error!._code) else { return }
                if errorCode == AuthErrorCode.requiresRecentLogin {
                    let alert = UIAlertController(title: "Uh-oh", message: "Please log out and log in to change your email.", preferredStyle: .alert)
                    self.present(alert, animated: true, completion:{
                        alert.view.superview?.isUserInteractionEnabled = true
                        alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                    })
                }
                if error != nil{
                    //Phone wrong
                    print(error)
                    self.lineOutlet.image = UIImage(named: "Line 2Red")
                    self.phoneIcon.image = UIImage(named: "Phone Icon Red")
                    self.phoneField.attributedPlaceholder = NSAttributedString(string: "Wrong passcode entered", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                    self.phoneField.text = ""
                    return
                }
                UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                    self.lineOutlet.alpha = 0
                    self.phoneIcon.alpha = 0
                    self.phoneField.alpha = 0
                    self.nextButtonOutlet.alpha = 0
                    self.lineOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.phoneField.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.phoneIcon.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.phoneVerificationIcon.transform = CGAffineTransform(translationX: 375, y: 0)
                    self.verificationField.transform = CGAffineTransform(translationX: 375, y: 0)
                }) { (_) in
                    UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                        // change icons and text
                        self.nextButtonOutlet.isEnabled = false
                        self.submitButton.isUserInteractionEnabled = true
                    }) { (_) in
                        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                            self.lineOutlet.alpha = 1
                            self.verificationField.alpha = 1
                            self.phoneVerificationIcon.alpha = 1
                            self.submitButton.alpha = 1
                            self.lineOutlet.transform = self.lineOutlet.transform.translatedBy(x: -375, y: 0)
                            self.verificationField.transform = self.verificationField.transform.translatedBy(x: -375, y: 0)
                            self.phoneVerificationIcon.transform = self.phoneVerificationIcon.transform.translatedBy(x: -375, y: 0)
                        })
                    }
                }
                self.verificationSent = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.submitButton.alpha = 0
        self.verificationField.alpha = 0
        self.submitButton.isUserInteractionEnabled = false
        self.phoneVerificationIcon.alpha = 0
        self.lineOutlet.image = UIImage(named: "Line 2")
        self.phoneVerificationIcon.image = UIImage(named: "Text Confirm Icon")
        self.phoneIcon.image = UIImage(named: "Phone Icon")
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

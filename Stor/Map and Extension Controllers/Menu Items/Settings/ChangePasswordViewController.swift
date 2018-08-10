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
    @IBOutlet weak var eyeOutlet: UIButton!
    @IBOutlet weak var enterCurrentPasswordLabel: UILabel!
    @IBOutlet weak var enterNewPasswordLabel2: UILabel!
    @IBOutlet weak var enterNewPasswordLabel1: UILabel!
    @IBOutlet weak var nextButtonOutlet: UIButton!
    @IBOutlet weak var lineMiddleOutlet: UIImageView!
    @IBOutlet weak var lineTopOutlet: UIImageView!
    @IBOutlet weak var lineBottomOutlet: UIImageView!
    @IBOutlet weak var middleImageOutlet: UIImageView!
    @IBOutlet weak var topImageOutlet: UIImageView!
    @IBOutlet weak var bottomImageOutlet: UIImageView!
    @IBOutlet weak var clickLabelOutlet: UILabel!
    @IBOutlet weak var hereButtonOutlet: UIButton!

    
    
    
    
    var passwordCheck = false
    var iconClick: Bool!
    
    @IBAction func submitAction(_ sender: Any) {
        let characterset = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        if newPassword.text! != confirmPassword.text!{
            print("Passwords don't match")
            // PASSWORDS DON'T MATCH
            self.newPassword.text = ""
            self.confirmPassword.text = ""
            self.newPassword.attributedPlaceholder = NSAttributedString(string: "Passwords do not match", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.confirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.lineTopOutlet.image = UIImage(named: "Line 2Red")
            self.lineBottomOutlet.image = UIImage(named: "Line 2Red")
            self.bottomImageOutlet.image = UIImage(named: "Confirm Password Icon Red")
            self.topImageOutlet.image = UIImage(named: "Red Lock")
        }
        else if newPassword.text!.count < 6{
            print("Password must be at least 6 characters!")
            // Must at least be 6 characters
            self.newPassword.text = ""
            self.confirmPassword.text = ""
            self.newPassword.attributedPlaceholder = NSAttributedString(string: "Password must be at least six characters", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.confirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.lineTopOutlet.image = UIImage(named: "Line 2Red")
            self.lineBottomOutlet.image = UIImage(named: "Line 2Red")
            self.bottomImageOutlet.image = UIImage(named: "Confirm Password Icon Red")
            self.topImageOutlet.image = UIImage(named: "Red Lock")
        }
        else if newPassword.text?.rangeOfCharacter(from: characterset.inverted) == nil{
            print("Must have at least 1 special character")
            self.newPassword.text = ""
            self.confirmPassword.text = ""
            self.newPassword.attributedPlaceholder = NSAttributedString(string: "Password must have at least one special character", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.confirmPassword.attributedPlaceholder = NSAttributedString(string: "Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.lineTopOutlet.image = UIImage(named: "Line 2Red")
            self.lineBottomOutlet.image = UIImage(named: "Line 2Red")
            self.bottomImageOutlet.image = UIImage(named: "Confirm Password Icon Red")
            self.topImageOutlet.image = UIImage(named: "Red Lock")
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
                        // add in "Can't update database. Please try again
                        let alert = UIAlertController(title: "Uh-oh", message: "Please try again. Servers may be busy.", preferredStyle: .alert)
                        self.present(alert, animated: true, completion:{
                            alert.view.superview?.isUserInteractionEnabled = true
                            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                        })
                    }
                    else{
                        userReference.updateChildValues(registerDataValues, withCompletionBlock: { (error, registerDataValues) in
                            if error != nil{
                                print(error)
                                let alert = UIAlertController(title: "Uh-oh", message: "Please try again. Servers may be busy", preferredStyle: .alert)
                                self.present(alert, animated: true, completion:{
                                    alert.view.superview?.isUserInteractionEnabled = true
                                    alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                                })
                                return
                                //ERROR CHANGING CHILD VALUE PASSWORD IN DATABASE
                            }
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                })
            
            }
        }
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lineBottomOutlet.image = UIImage(named: "Line 2")
        lineTopOutlet.image = UIImage(named: "Line 2")
        lineMiddleOutlet.image = UIImage(named: "Line 2")
        lineBottomOutlet.alpha = 0
        lineTopOutlet.alpha = 0
        newPassword.alpha = 0
        confirmPassword.alpha = 0
        iconClick = false
        submitButton.isEnabled = false
        submitButton.alpha = 0
        enterNewPasswordLabel1.alpha = 0
        topImageOutlet.alpha = 0
        bottomImageOutlet.alpha = 0
        newPassword.isSecureTextEntry = true
        oldPassword.isSecureTextEntry = true
        confirmPassword.isSecureTextEntry = true
        topImageOutlet.image = UIImage(named: "Combined Shape2-1")
        middleImageOutlet.image = UIImage(named: "Old Password")
        bottomImageOutlet.image = UIImage(named: "Confirm Password Icon")
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
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
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
                            UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseIn, animations: {
                                self.oldPassword.alpha = 0
                                self.eyeOutlet.alpha = 0
                                self.nextButtonOutlet.alpha = 0
                                self.enterCurrentPasswordLabel.alpha = 0
                                self.enterNewPasswordLabel2.alpha = 0
                                self.hereButtonOutlet.alpha = 0
                                self.clickLabelOutlet.alpha = 0
                                self.enterNewPasswordLabel1.alpha = 0
                                self.middleImageOutlet.alpha = 0
                                self.lineMiddleOutlet.alpha = 0
                                self.oldPassword.transform = CGAffineTransform(translationX: 375, y: 0)
                                self.newPassword.transform = CGAffineTransform(translationX: 375, y: 0)
                                self.confirmPassword.transform = CGAffineTransform(translationX: 375, y: 0)
                                self.eyeOutlet.transform = CGAffineTransform(translationX: 375, y: 0)
                            }) { (_) in
                                UIView.animate(withDuration: 0 , delay: 0, options: .curveLinear, animations: {
                                    // change icons and text
                                    self.eyeOutlet.transform = CGAffineTransform(translationX: 0, y: -43)
                                    self.iconClick = false
                                    self.oldPassword.isSecureTextEntry = true
                                    self.newPassword.isSecureTextEntry = true
                                    self.confirmPassword.isSecureTextEntry = true
                                    self.eyeOutlet.setImage(#imageLiteral(resourceName: "crossed out eye"), for: .normal)
                                    self.nextButtonOutlet.isEnabled = false
                                    self.submitButton.isEnabled = true
                                }) { (_) in
                                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
                                        self.enterNewPasswordLabel1.alpha = 1
                                        self.submitButton.alpha = 1
                                        self.eyeOutlet.alpha = 1
                                        self.confirmPassword.alpha = 1
                                        self.newPassword.alpha = 1
                                        self.lineBottomOutlet.alpha = 1
                                        self.lineTopOutlet.alpha = 1
                                        self.bottomImageOutlet.alpha = 1
                                        self.topImageOutlet.alpha = 1
                                        self.newPassword.transform = self.newPassword.transform.translatedBy(x: -375, y: 0)
                                        self.confirmPassword.transform = self.confirmPassword.transform.translatedBy(x: -375, y: 0)
                                    })
                                }
                            }
                        }
                        else{
                            //show error message
                            self.lineMiddleOutlet.image = UIImage(named: "Line 2Red")
                            self.middleImageOutlet.image = UIImage(named: "Old Password Red")
                            self.oldPassword.text = ""
                            self.oldPassword.attributedPlaceholder = NSAttributedString(string: "Incorrect password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        }
                    }
                })
            }
        }
    }
    
    
    @IBAction func eyeButton(_ sender: UIButton) {
        if(iconClick == false) {
            oldPassword.isSecureTextEntry = false
            newPassword.isSecureTextEntry = false
            confirmPassword.isSecureTextEntry = false
            iconClick = true
            UIView.animate(withDuration: 0.1, animations: {
                self.eyeOutlet.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
                    self.eyeOutlet.setImage(#imageLiteral(resourceName: "crossed out eye"), for: .normal)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.eyeOutlet.alpha = 1
                    })
                }
            }
        }
        else{
            oldPassword.isSecureTextEntry = true
            newPassword.isSecureTextEntry = true
            confirmPassword.isSecureTextEntry = true
            iconClick = false
            UIView.animate(withDuration: 0.1, animations: {
                self.eyeOutlet.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0, delay: 0, options: .curveLinear, animations: {
                    self.eyeOutlet.setImage(#imageLiteral(resourceName: "Combined Shape3-1"), for: .normal)
                }) { (_) in
                    UIView.animate(withDuration: 0.1, animations: {
                        self.eyeOutlet.alpha = 1
                    })
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

}

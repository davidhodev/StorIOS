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
    

    @IBOutlet weak var bottomImageOutlet: UIImageView!
    @IBOutlet weak var bottomLineOutlet: UIImageView!
    @IBOutlet weak var topLineOutlet: UIImageView!
    @IBOutlet weak var topImageOutlet: UIImageView!
    
    @IBOutlet weak var oldEmail: UITextField! // Means Confirm Email
    @IBOutlet weak var newEmail: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButtonPressed(_ sender: Any) {
        if oldEmail.text! != newEmail.text!{
            // Emails don't match
            self.bottomLineOutlet.image = UIImage(named: "Line 2Red")
            self.topLineOutlet.image = UIImage(named: "Line 2Red")
            self.topImageOutlet.image = UIImage(named: "Mail Icon Red")
            self.bottomImageOutlet.image = UIImage(named: "RedoEmailRed")
            self.newEmail.text = ""
            self.oldEmail.text = ""
            self.newEmail.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
            self.oldEmail.attributedPlaceholder = NSAttributedString(string: "Entries do not match", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
        }
        else{
            if let user = Auth.auth().currentUser{
                let registerDataValues = ["email": oldEmail.text ] as [String : Any]
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((user.uid))
                
                user.updateEmail(to: oldEmail.text!, completion: { (error) in
                    if error != nil{
                        print(error)
                        // Means invalid Email
                        // Do stuff to turn red / make error changes
                        self.bottomLineOutlet.image = UIImage(named: "Line 2Red")
                        self.topLineOutlet.image = UIImage(named: "Line 2Red")
                        self.topImageOutlet.image = UIImage(named: "Mail Icon Red")
                        self.bottomImageOutlet.image = UIImage(named: "RedoEmailRed")
                        self.newEmail.text = ""
                        self.oldEmail.text = ""
                        self.newEmail.attributedPlaceholder = NSAttributedString(string: "Confirm Email Address", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                        self.oldEmail.attributedPlaceholder = NSAttributedString(string: "Invalid email entered", attributes: [NSAttributedStringKey.foregroundColor: UIColor.init(red: 204/340, green: 17/340, blue: 119/340, alpha: 0.3)])
                    }
                    else{
                        userReference.updateChildValues(registerDataValues, withCompletionBlock: { (error, registerDataValues) in
                            if error != nil{
                                print(error)
                                let alert = UIAlertController(title: "Uh-oh", message: "Please try again. Servers may be busy.", preferredStyle: .alert)
                                self.present(alert, animated: true, completion:{
                                    alert.view.superview?.isUserInteractionEnabled = true
                                    alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                                })
                                return
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
        bottomLineOutlet.image = UIImage(named: "Line 2")
        topLineOutlet.image = UIImage(named: "Line 2")
        bottomImageOutlet.image = UIImage(named: "RedoEmail")
        topImageOutlet.image = UIImage(named: "Combined Shape1")
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

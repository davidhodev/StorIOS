//
//  registerProviderViewController.swift
//  Stor
//
//  Created by David Ho on 6/13/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class registerProviderViewController: UIViewController {

    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var socialSecurityTextField: UITextField!
    @IBOutlet weak var permanentAddressLabel: UITextField!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var submitButton: UIButton!
    @IBAction func submitButtonPressed(_ sender: Any) {
        if checkInputs(){
            makeProvider()
        }

    }
    
    func checkInputs() -> Bool{
        if socialSecurityTextField.text?.count != 9{
            print("SSN Not 9 digits")
            return false
        }
        return true
    }
    
    
    
    
    func makeProvider(){
        guard let socialSecurityVerify = socialSecurityTextField.text else {return}
        guard  let permanentAddress = permanentAddressLabel.text else {return}
        
        if let user = Auth.auth().currentUser{
            print(1)
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let userReference = databaseReference.root.child("Users").child((user.uid))
            print(2)
            userReference.observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    print(3)
                    let registerDataValues = ["Name": dictionary["name"], "SocialSecurity": socialSecurityVerify, "numberOfRatings": 1, "rating": 5, "phone": dictionary["phone"], "profileImage": dictionary["profilePicture"], "backgroundCheck": "pending"]
                    databaseReference.child("Providers").child(user.uid).child("personalInfo").updateChildValues(registerDataValues)
                    
                    
                    self.performSegue(withIdentifier: "socialToMenuSegue", sender: nil)
                    
                    providerMenuPopup.shared.providerMenuVC.showPopUp()
                    registerProviderViewController().dismiss(animated: true)

                }
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
    func hideKeyboardWhenTappedAround() {
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(RegisterEmailViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}

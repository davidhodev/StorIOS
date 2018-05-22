//
//  StartupViewController.swift
//  Stor
//
//  Created by David Ho on 5/21/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class StartupViewController: UIViewController {

    // Instantiate create account button
    @IBOutlet weak var createAccountButton: UIButton!
    
    // Create Button Function
    @IBAction func CreateAccountButtonPressed(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createAccount:RegisterEmailViewController = storyboard.instantiateViewController(withIdentifier:"RegisterEmailViewController") as! RegisterEmailViewController
        self.present(createAccount, animated: true, completion: nil)
    }
    
    // Login Button Function
    @IBAction func loginButtonPressed(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginPage:LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginPage, animated: true, completion: nil)
    }
    
    //When Facebook Button Pressed
    @IBAction func facebookButton(_ sender: Any) {
        handleFacebookButton()
    }
    
    
    func handleFacebookButton(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self){ (result, error) in
            if (error != nil){
                print("Facebook Login Error", error)
                return
                
            }
            
            //Getting Facebook Credentials
            let fbAccessToken = FBSDKAccessToken.current()
            guard let accessTokenString = fbAccessToken?.tokenString else { return }
                
            let credentials = FacebookAuthProvider.credential(withAccessToken: (fbAccessToken?.tokenString)!)
            Auth.auth().signIn(with: credentials, completion: { (user, error) in
                if (error != nil){
                    print ("Facebook login went wrong")
                    return
                }
                print ("Logged in With Facebook!")
                self.viewDidLoad()
                
            })
            
            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{ (connection, result, err) in
                if (err != nil){
                    print("Could not get graph request")
                    return
                }
                print(result)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Override viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let user = Auth.auth().currentUser{
            performSegue(withIdentifier: "toMapSegue", sender: nil)
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

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
import GoogleSignIn


class StartupViewController: UIViewController, GIDSignInUIDelegate{

    // Instantiate create account button
    @IBOutlet weak var createAccountButton: UIButton!
    
    // Create Button Function
    @IBAction func CreateAccountButtonPressed(_ sender: UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let goToAccountPage:RegisterEmailViewController = storyboard.instantiateViewController(withIdentifier:"RegisterEmailViewController") as! RegisterEmailViewController
        self.navigationController?.pushViewController(goToAccountPage, animated: true)
    }
 
    // Login Button Function
    @IBAction func loginButtonPressed(_ sender: Any) {
        //print("Login button")
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginPage:LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginPage, animated: true)
    }
    
    // Help? Button Function
    // change from Google to our FAQ
    @IBAction func helpButtonPressed(_ sender: UIButton) {
    
    openUrl(urlStr: "http://www.google.com")
    }

    func openUrl(urlStr:String!) {
    
    if let url = NSURL(string:urlStr) {
        UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    

//    terms and conditions button function
    @IBAction func termsButtonPressed(_ sender: UIButton?) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let termsPage: TermsViewController = storyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
        self.navigationController?.pushViewController(termsPage, animated: true)
    }
    
    
    
    
    //When Facebook Button Pressed
    @IBAction func facebookButton(_ sender: Any) {
        handleFacebookButton()
    }
    
    // When Google Button Pressed
    @IBAction func googleButton(_ sender: Any) {
        handleGoogleButton()
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
                //Get Facebook Info
                FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start{ (connection, result, err) in
                    if (err != nil){
                        print("Could not get graph request")
                        return
                    }
                    print(result)
                    self.viewDidAppear(true)
                }
            })
        }
    }
    
    // Google button press function
    func handleGoogleButton(){
        GIDSignIn.sharedInstance().signIn()
        viewDidAppear(true)
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().uiDelegate = self

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


    // Override viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
        
    }

}

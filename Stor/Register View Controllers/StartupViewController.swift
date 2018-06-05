//
//  StartupViewController.swift
//  Stor
//
//  Created by David Ho on 5/21/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FBSDKLoginKit
import GoogleSignIn


class StartupViewController: UIViewController, GIDSignInUIDelegate{

    // Instantiate create account button
    @IBOutlet weak var createAccountButton: UIButton!
    
    // Create Button Function
    
    @IBAction func createAccountButton(_ sender: UIButton) {
    let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let goToAccountPage:RegisterEmailViewController = storyboard.instantiateViewController(withIdentifier:"RegisterEmailViewController") as! RegisterEmailViewController
        self.navigationController?.pushViewController(goToAccountPage, animated: true)
    }
 
    // Login Button Function
    @IBAction func loginButton(_ sender: UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginPage: LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
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
                self.getFacebookInfo()
                self.viewDidAppear(true)
            })
        }
    }
    
    // Get Facebook Info Func
    func getFacebookInfo(){
        var fbName = ""
        var fbEmail = ""
        var fbPhoto = ""
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email, picture.type(large)"]).start{ (connection, result, err) in
            if (err != nil){
                print("Could not get graph request")
                return
            }
            print("FBRESULT", result)
            
            let info = result as! [String : AnyObject]
            if let name = info["name"] as? String{
                fbName = name
            }
            if let email = info["email"] as? String{
                fbEmail = email
            }
            
            if let photo = info["picture"] as? NSDictionary, let fbData = photo["data"] as? NSDictionary, let fbPhotoUrl = fbData["url"] as? String{
                print(fbData)
                fbPhoto = fbPhotoUrl
            }
            let fbUrl = URL(string:fbPhoto)
            
            if let user = Auth.auth().currentUser{
                let registerDataValues = ["name": fbName, "email": fbEmail, "password": user.uid, "phone":"phoneVerify", "profilePicture": fbPhoto, "rating": 5, "numberOfRatings": 1 ] as [String : Any]
                
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((user.uid))
                
                databaseReference.child("Users").child((user.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
                    if snapshot.hasChild("rating"){
                        print("IT HAS A RATING")
                    }
                    else{
                        userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                            if err != nil{
                                print(err)
                                return
                            }
                            print("User successfully saved to FIREBASE!")
                        })
                    }
                })
            }
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

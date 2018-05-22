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
    @IBAction func CreateAccountButtonPressed(_ sender: UIButton) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let createAccount:RegisterEmailViewController = storyboard.instantiateViewController(withIdentifier:"RegisterEmailViewController") as! RegisterEmailViewController
        self.navigationController?.pushViewController(createAccount, animated: true)
    }
 
    // Login Button Func tion
    @IBAction func loginButtonPressed(_ sender: Any) {
        let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let loginPage:LoginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.navigationController?.pushViewController(loginPage, animated: true)
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
    // Override viewWillAppear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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

//
//  AppDelegate.swift
//  Stor
//
//  Created by David Ho on 4/26/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Installing Firebase
        FirebaseApp.configure()
        
        //Installing Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self

        return true
    }
    
    // Facebook and Google SDK function
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
        
    
        return handle
        
    }

    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error{
            print("Failed to log in to Google", error)
            return
        }
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        let credentials = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        
        Auth.auth().signIn(with: credentials, completion: {
            (user,error) in
            if let error = error {
                print ("Failed to make a Firebase account with Google")
                return
            }
            else{ print("Google Firebase Success!", user?.uid)
                
                let fullName = user?.displayName
                let email = user?.email
                let profilePic = user?.photoURL
                let phone = user?.phoneNumber
                let profilePicString = profilePic?.absoluteString
                
                if let user = Auth.auth().currentUser{
                    let registerDataValues = ["name": fullName, "email": email, "password": user.uid, "phone":phone, "profile Picture": profilePicString]
                    let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                    let userReference = databaseReference.root.child("Users").child((user.uid))
                    
                    userReference.updateChildValues(registerDataValues, withCompletionBlock: {(err, registerDataValues) in
                        if err != nil{
                            print(err)
                            return
                        }
                        print("User successfully saved to FIREBASE!")
                    })
                }
                if let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as? MapViewController {
                    if let window = self.window, let rootViewController = window.rootViewController {
                        var currentController = rootViewController
                        while let presentedController = currentController.presentedViewController {
                            currentController = presentedController
                        }
                        currentController.present(controller, animated: true, completion: nil)
                    }
                }
            }
        })
        print("Succesfully logged into Google", user)
        
    }
        

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}


//
//  AppDelegate.swift
//  Stor
//
//  Created by David Ho on 4/26/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseInstanceID
import FirebaseDatabase
import FirebaseMessaging
import FBSDKCoreKit
import FBSDKLoginKit
import GoogleSignIn
import UserNotifications
import Stripe


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate, UNUserNotificationCenterDelegate, MessagingDelegate{

    var window: UIWindow?
    static let NOTIFICATION_URL = "https://gcm-http.googleapis.com/gcm/send"
    static var DEVICEID = String()
    static let SERVERKEY = "AAAAc5bW2po:APA91bF5n0a-ubA8Mzv7oEf6lMBI9Q6CBiqOpMGf7V8REIAQBSmFvPZtg8RaBmqOGBsSugd8Mck49K85p-jokRsa0sDPxnJvsYUBaovQemslwu1q3W5wXIdHtIVFePrW2v4ZT7laphMD"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //User Notifications
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (isGranted, error) in
            if error != nil{
                // Something Went wrong
                print("User Notification Error")
            }
            else{
                UNUserNotificationCenter.current().delegate = self
                Messaging.messaging().delegate = self
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    UIApplication.shared.applicationIconBadgeNumber = 0
                }
            }
        }
        
        // Stripe
        STPPaymentConfiguration.shared().publishableKey = "pk_test_YiFob2dQ8egZGaTV7iBDgtOz"
        
        
        //Facebook SDK
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        // Installing Firebase
        FirebaseApp.configure()
        
        
        //Installing Google
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        

        return true
    }
    
    //Connecting to Firebase Connection Manager
    func ConnectToFCM(){
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    
    
    // Facebook and Google SDK function
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handle = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
        let stripeHandled = Stripe.handleURLCallback(with: url)

        if (stripeHandled) {
            return true
        }
    
        GIDSignIn.sharedInstance().handle(url, sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
    
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
                let profilePic = GIDSignIn.sharedInstance().currentUser.profile.imageURL(withDimension: 400).absoluteString
                var phone: String?
                if user?.phoneNumber != nil{
                    phone = user?.phoneNumber
                }
                else{
                    phone = "phoneVerify"
                }
                
                if let user = Auth.auth().currentUser{
                    let registerDataValues = ["name": fullName, "email": email, "password": user.uid, "phone":phone, "profilePicture": profilePic, "rating": 5, "numberOfRatings": 1,  "deviceToken": AppDelegate.DEVICEID] as [String : Any]
                    
                    //"rating": 5, "numberOfRatings": 1
                    let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                    let userReference = databaseReference.root.child("Users").child((user.uid))
                    databaseReference.child("Users").child((user.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
                        print("SNAPSHOT", snapshot)
                        print("USER ID", user.uid)
                        if snapshot.hasChild("rating"){
                            print("IT HAS A RATING")
                        }
                        else{
                            print("Here")
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
        
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        // Connecting to FCM
        ConnectToFCM()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        guard let newToken = InstanceID.instanceID().token() else {return}
        AppDelegate.DEVICEID = newToken
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let notification = response.notification.request.content.body
        print(notification)
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print(notification)
        completionHandler([.alert])
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        guard let token = InstanceID.instanceID().token() else {return}
        AppDelegate.DEVICEID = token
    }
    
    // This method is where you handle URL opens if you are using univeral link URLs (eg "https://example.com/stripe_ios_callback")
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            if let url = userActivity.webpageURL {
                let stripeHandled = Stripe.handleURLCallback(with: url)
                
                if (stripeHandled) {
                    return true
                }
                else {
                    // This was not a stripe url, do whatever url handling your app
                    // normally does, if any.
                }
            }
            
        }
        return false
    }
    
}


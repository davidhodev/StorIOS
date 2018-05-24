//
//  MapViewController.swift
//  Stor
//
//  Created by David Ho on 5/22/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var storMapKit: MKMapView!
    
    // instantiate the View
    @IBOutlet var popMenu: UIView!
    
    // exit button
    @IBAction func exitMenu(_ sender: UIButton) {
        animateOut()
    }
    // menu animation
    func animateIn() {
        self.view.addSubview(popMenu)
        popMenu.center = self.view.center
        popMenu.transform = CGAffineTransform.init(scaleX: 1, y: 1)
        popMenu.alpha = 0
        UIView.animate(withDuration: 0.3){
            self.popMenu.alpha = 0.75
            self.popMenu.transform = CGAffineTransform.identity
        }
    }
    
    //menu exit animation
    func animateOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.popMenu.transform = CGAffineTransform.init(scaleX:1, y: 1)
            self.popMenu.alpha = 0
        }) {(success: Bool) in
                self.popMenu.removeFromSuperview()
            }
    }
    
    // menu button
    @IBAction func goToMenu(_ sender: UIButton) {
        animateIn()
    }
    
    
    let locationManager = CLLocationManager()
    
    //menu button function to bring out pop up
    @IBAction func menuButton(_ sender: UIButton) {
        
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try!  Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        let manager = FBSDKLoginManager()
        manager.logOut()
        
        print("signed out")
        self.navigationController?.popToRootViewController(animated: true)
//        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    

    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let center = location.coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01) //WHERE WE CHANGE THE SPAN OF MAP
        let region = MKCoordinateRegion(center: center, span: span)
        
        storMapKit.setRegion(region, animated: true)
        storMapKit.showsUserLocation = true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

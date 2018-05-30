//
//  MapViewController.swift
//  Stor
//
//  Created by David Ho on 5/22/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleSignIn
import FBSDKLoginKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate{
    
    
    // Instantiating Variables
    @IBOutlet weak var storMapKit: MKMapView!
    @IBOutlet weak var textXan: UITextField!
    
    let locationManager = CLLocationManager()
    var myPin:Annotations!
    var providers = [Annotations]()
    
    
    // LogOut
    @IBAction func logoutButtonPressed(_ sender: Any) {
        try!  Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        let manager = FBSDKLoginManager()
        manager.logOut()
        
        print("signed out")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storMapKit.delegate = self
        textXan.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        storMapKit.showsUserLocation = true
        
        // Get Data for the Menu
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String:Any] {
                globalVariablesViewController.username = (dictionary["name"] as? String)!
                globalVariablesViewController.ratingNumber = (dictionary["rating"] as? NSNumber)!
                globalVariablesViewController.profilePicString = (dictionary["profilePicture"] as? String)!
            }
        }, withCancel: nil)
        
        // Show Annotations
        fetchProviders()
    }
    
    
    // Updating Locations
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let center = self.storMapKit.userLocation.coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01) //WHERE WE CHANGE THE SPAN OF MAP
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.storMapKit.showsPointsOfInterest = false
        storMapKit.setRegion(region, animated: false)
        storMapKit.showsUserLocation = true
    }
    
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // Text Bar When Entered Function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = textXan.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.storMapKit.setRegion(region, animated: true)
        }
        return false
    }
    
    // Getting Providers Info from database
    func fetchProviders(){
        Database.database().reference().child("Providers").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            if let dictionary = snapshot.value as? [String: Any]{
                let providerAddress = (dictionary["Address"] as! String)
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(providerAddress, completionHandler: { (placemarks, error) in
                    guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        print("NO LOCATION FOUND")
                        return
                    }
                    let provider = Annotations(title: dictionary["Title"] as! String, subtitle: dictionary["Subtitle"] as! String, address: dictionary["Address"] as! String, coordinate: location.coordinate)
                    self.storMapKit.addAnnotation(provider)
                }
            )}
        }, withCancel: nil)
    }
}

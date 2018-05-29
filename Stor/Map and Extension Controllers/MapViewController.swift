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
import GoogleMaps
import GooglePlaces
import FBSDKLoginKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, GMSAutocompleteViewControllerDelegate{
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        let lat = place.coordinate.latitude
        let long = place.coordinate.longitude
        
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegionMake(coordinate, span)
        self.storMapKit.setRegion(region, animated: true)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print(error)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    @IBOutlet weak var storMapKit: MKMapView!
    @IBOutlet weak var searchXan: UISearchBar!
    
    let locationManager = CLLocationManager()
    var myPin:Annotations!
    var providers = [Annotations]()
    
    
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
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
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

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let center = self.storMapKit.userLocation.coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01) //WHERE WE CHANGE THE SPAN OF MAP
        let region = MKCoordinateRegion(center: center, span: span)
        
        self.storMapKit.showsPointsOfInterest = false
        storMapKit.setRegion(region, animated: true)
        storMapKit.showsUserLocation = true
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: myPin, reuseIdentifier: "TESTPIN1")
//        annotationView.image = UIImage(named: "")
//        let transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
//        annotationView.transform = transform
        return annotationView
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Search Bar When Clicked
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        let filter = GMSAutocompleteFilter()
        autoCompleteController.autocompleteFilter = filter
        
        self.locationManager.startUpdatingLocation()
        self.present(autoCompleteController, animated: true, completion: nil)
        return false
    }
    
    
    
    
    
    // Search Bar When Entered Function
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let searchRequest = MKLocalSearchRequest()
        searchRequest.naturalLanguageQuery = searchXan.text
        
        let activeSearch = MKLocalSearch(request: searchRequest)
        activeSearch.start { (response, error) in
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.storMapKit.setRegion(region, animated: true)
            
        }
    }
    
    // Getting Providers Info from database
    func fetchProviders(){
        print("estyy")
        print("PROVIDER FOUND")
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
            )
            }
        }, withCancel: nil)
    }

}

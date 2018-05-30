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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, MKLocalSearchCompleterDelegate, UITableViewDataSource, UITableViewDelegate{
    
    

    
    
    
    // Instantiating Variables
    @IBOutlet weak var storMapKit: MKMapView!
    @IBOutlet weak var textXan: UITextField!
    @IBOutlet weak var searchResultsTableView: UITableView!
    @IBOutlet weak var outOfAuto: UIButton!
    @IBAction func outOfAutoComplete(_ sender: Any) {
        searchResultsTableView.isHidden = true
        outOfAuto.isHidden = true
    }
    
    // text xan image insets
   
    
    let locationManager = CLLocationManager()
    var myPin:Annotations!
    var providers = [Annotations]()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    
    
    
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
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        

        outOfAuto.isHidden = true
        searchResultsTableView.isHidden = true
        
        textXan.addTarget(self, action: #selector(MapViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchResultsTableView.isHidden = false
        outOfAuto.isHidden = false
    }
    
    //Text Bar Pressed
    @objc func textFieldDidChange(_ textField: UITextField) {
        searchResultsTableView.isHidden = false
        outOfAuto.isHidden = false
        searchCompleter.queryFragment = textField.text!
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results
        searchResultsTableView.reloadData()
    }
    
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print(error)
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchResult = searchResults[indexPath.row]
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        cell.textLabel?.text = searchResult.title
        cell.detailTextLabel?.text = searchResult.subtitle
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let completion = searchResults[indexPath.row]
        
        let searchRequest = MKLocalSearchRequest(completion: completion)
        let search = MKLocalSearch(request: searchRequest)
        search.start { (response, error) in
            let latitude = response?.boundingRegion.center.latitude
            let longitude = response?.boundingRegion.center.longitude
            
            let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude!, longitude!)
            let span = MKCoordinateSpanMake(0.01, 0.01)
            let region = MKCoordinateRegionMake(coordinate, span)
            self.storMapKit.setRegion(region, animated: true)
            self.searchResultsTableView.isHidden = true
            self.outOfAuto.isHidden = true
        }
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
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }
        let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "provider")
        annotationView.image = UIImage(named: "Map Pin Background")
//        annotationView.canShowCallout = true
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: "AnnotationPopUpSegue", sender: self)
        mapView.deselectAnnotation(view.annotation, animated: true)
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
                    provider.image = #imageLiteral(resourceName: "Map Pin Background")
                    self.providers.append(provider)
                    self.storMapKit.addAnnotation(provider)
                    
                }
            )}
        }, withCancel: nil)
    }
}

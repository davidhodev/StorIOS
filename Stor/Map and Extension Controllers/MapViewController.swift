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
    
     var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    @IBAction func outOfAutoComplete(_ sender: Any) {
        searchResultsTableView.isHidden = true
        outOfAuto.isHidden = true
        cancelButton.isHidden = true
    }
    
    // centers the screen back on the user's location
    @IBAction func reCenterButton(_ sender: UIButton) {
        let center = self.storMapKit.userLocation.coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01) //WHERE WE CHANGE THE SPAN OF MAP
        let region = MKCoordinateRegion(center: center, span: span)
        storMapKit.setRegion(region, animated: true)
    }
    @IBOutlet weak var reCenterShowButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButtonFunction(_ sender: Any) {
        textXan.text! = ""
    }
    @IBOutlet weak var filterButton: UIButton!
    @IBAction func filterButtonFunction(_ sender: Any) {
        print("FILTER")
    }
    // text xan image insets
   
    
    let locationManager = CLLocationManager()
    var myPin:Annotations!
    var providers = [Annotations]()
    var searchCompleter = MKLocalSearchCompleter()
    var searchResults = [MKLocalSearchCompletion]()
    var annotationUID: String?
    var annotationAddress: String?
    var annotationStorageID: String?
    var annotationLocation: CLLocationCoordinate2D?
    var annotationUserLocation :CLLocation?
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        storMapKit.delegate = self
        textXan.delegate = self
        locationManager.delegate = self
        searchCompleter.delegate = self
        searchResultsTableView.delegate = self
        searchResultsTableView.dataSource = self
        self.reCenterShowButton.isHidden = true
        self.searchResultsTableView.layer.cornerRadius = 30
        self.searchResultsTableView.layer.masksToBounds = true

        outOfAuto.isHidden = true
        searchResultsTableView.isHidden = true
        cancelButton.isHidden = true
        
        textXan.addTarget(self, action: #selector(MapViewController.textFieldDidChange(_:)), for: UIControlEvents.editingChanged)
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        storMapKit.showsUserLocation = true
        
        // Get Data for the Menu
        let uid = Auth.auth().currentUser?.uid
        //Activity Indicator
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
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
    
    

    
    
    // Updating Locations, old way of zooming in on user location
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        let center = self.storMapKit.userLocation.coordinate
//        let span = MKCoordinateSpanMake(0.01, 0.01) //WHERE WE CHANGE THE SPAN OF MAP
//        let region = MKCoordinateRegion(center: center, span: span)
        self.storMapKit.showsPointsOfInterest = false
//        storMapKit.setRegion(region, animated: true)
//        storMapKit.showsUserLocation = true

    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        reCenterShowButton.isHidden = self.storMapKit.isUserLocationVisible
    }
    
    // new way of zooming in on user location
    func mapViewDidFinishRenderingMap(_ mapView: MKMapView, fullyRendered: Bool) {
        let center = self.storMapKit.userLocation.coordinate
        let span = MKCoordinateSpanMake(0.01, 0.01) //WHERE WE CHANGE THE SPAN OF MAP
        let region = MKCoordinateRegion(center: center, span: span)
        storMapKit.setRegion(region, animated: true)
        storMapKit.showsUserLocation = true
        locationManager.stopUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.searchResultsTableView.isHidden = false
        self.outOfAuto.isHidden = false
        self.cancelButton.isHidden = false
    }
    
    //Text Bar Pressed
    @objc func textFieldDidChange(_ textField: UITextField) {
        self.searchResultsTableView.isHidden = false
        self.outOfAuto.isHidden = false
        self.cancelButton.isHidden = false
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
        
        cell.textLabel?.attributedText = highlightedText(searchResult.title, inRanges: searchResult.titleHighlightRanges, size: 17.0)
        cell.detailTextLabel?.attributedText = highlightedText(searchResult.subtitle, inRanges: searchResult.subtitleHighlightRanges, size: 12.0)
        cell.textLabel?.font = UIFont(name: "Dosis", size: 17.0)
        cell.textLabel?.font = UIFont(name: "Dosis", size: 12.0)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if(indexPath.row % 2 == 1){
            cell.backgroundColor = UIColor(red: 247/743, green: 247/743, blue:249/743, alpha:0.06)
            //F7f7f9 alpha .6
        }
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
            self.cancelButton.isHidden = true
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
        let transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
        annotationView.transform = transform
        return annotationView
        
    }
    // brings you to specific annotation page and brings over information
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let annotation = view.annotation as! Annotations
        self.annotationLocation = annotation.coordinate
        self.annotationAddress = annotation.address
        self.annotationUID = annotation.providerUID
        self.annotationStorageID = annotation.storageUID
        performSegue(withIdentifier: "AnnotationPopUpSegue", sender: self)
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
    
    // Segue Helper (SENDS INFO TO POPUP)
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AnnotationPopUpSegue"{
            let destinationController = segue.destination as! AnnotationPopUp
            destinationController.providerID = self.annotationUID
            destinationController.providerAddress = self.annotationAddress
            destinationController.storageID = self.annotationStorageID
            destinationController.providerLocation = self.annotationLocation
            destinationController.userLocation = self.storMapKit.userLocation.location
        }
    }
    
    
    
    
    func highlightedText(_ text: String, inRanges ranges: [NSValue], size: CGFloat) -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: text)
        let regular = UIFont.systemFont(ofSize: size)
        attributedText.addAttribute(NSAttributedStringKey.font, value:regular, range:NSMakeRange(0, text.count))
        
        let bold = UIFont.boldSystemFont(ofSize: size)
        for value in ranges {
            attributedText.addAttribute(NSAttributedStringKey.font, value:bold, range:value.rangeValue)
        }
        
        attributedText.accessibilityAssistiveTechnologyFocusedIdentifiers()
        return attributedText
    }
    
    
    
    // Getting Providers Info from database
    func fetchProviders(){
        Database.database().reference().child("Providers").observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
            if let dictionary = snapshot.value as? [String: Any]{
                let providerStorageDictionary = (dictionary["currentStorage"] as? [String: Any])
                let storageUID = (Array(providerStorageDictionary!.keys)[0])
                self.annotationStorageID = storageUID
                let actualStorageDictionary = providerStorageDictionary![storageUID] as? [String: Any]
                let providerAddress = actualStorageDictionary!["Address"] as? String
                let geocoder = CLGeocoder()
                geocoder.geocodeAddressString(providerAddress!, completionHandler: { (placemarks, error) in
                    guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        print("NO LOCATION FOUND")
                        return
                    }
                    print(snapshot.key)
                    
                    let provider = Annotations(title: actualStorageDictionary!["Title"] as! String, subtitle: actualStorageDictionary!["Subtitle"] as! String, address: actualStorageDictionary!["Address"] as! String, coordinate: location.coordinate, providerUID: (snapshot.key), storageUID: storageUID)
                    provider.image = #imageLiteral(resourceName: "Map Pin Background")
                    self.providers.append(provider)
                    self.storMapKit.addAnnotation(provider)
                    UIApplication.shared.endIgnoringInteractionEvents()
                    self.activityIndicator.stopAnimating()
                }
            )}
        }, withCancel: nil)
    }
}

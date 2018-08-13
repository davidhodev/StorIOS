//
//  myListingViewController.swift
//  Stor
//
//  Created by David Ho on 6/18/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class myListingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var selectedIndexPath: IndexPath?
    var taken: Bool?
    var exists: Bool?
    var address: NSMutableAttributedString?
    var price: NSMutableAttributedString?
    var dimensions: NSMutableAttributedString?
    var cubicFeet: NSMutableAttributedString?
    var name: NSMutableAttributedString?
    var rating: NSMutableAttributedString?
    var phone: NSMutableAttributedString?
    var userProfile: UIImage?
    var phoneRaw: String?
    var dropOffTime: NSMutableAttributedString?
    var pickUpTime: NSMutableAttributedString?
    var time: NSMutableAttributedString?
    
    var newActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var counter = 0
    
    @IBOutlet var myListingView: UIView!
    @IBOutlet weak var noCurrentListing: UILabel!
    
    @IBOutlet weak var myListingTableView: UITableView!
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addListingButton(_ sender: Any) {
        if exists! == true{
            let alert = UIAlertController(title: "Uh-oh", message: "Looks like you already having a listing out! You are limitted to only 1 listing at a time. We apologize for the inconvenience. More listings will be allowed in the next update!", preferredStyle: .alert)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
        }
        else{
            performSegue(withIdentifier: "addListingSegue", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myListingTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! providerMyListingCellTableViewCell
        
        if (exists)!{
            cell.addressLabel.attributedText = self.address
            print(self.price)
            cell.priceLabel.attributedText = self.price
            cell.cubicFeetLabel.attributedText = self.cubicFeet
            cell.dimensionsLabel.attributedText = self.dimensions
            
            if (cell.contentView.bounds.size.height.rounded() == 60){
                cell.moreImage.image = UIImage(named: "Purple Expand Arrow")
            }
            else
            {
                print (cell.contentView.bounds.size.height)
                cell.moreImage.image = UIImage(named: "Purple Close arrow")
            }
            
            if taken!{
                cell.availableLabel.isHidden = true
                cell.nameLabel.attributedText = self.name
                cell.phoneLabel.attributedText = self.phone
                cell.ratingLabel.attributedText = self.rating
                cell.deleteButton.isHidden = true
                cell.deleteLabel.isHidden = true
                cell.editListingLabel.isHidden = true
                cell.editListingButton.isHidden = true
                cell.editDetailsButton.isHidden = true
                cell.dropOffTimeLabel.attributedText = self.dropOffTime
                cell.pickUpTimeLabel.attributedText = self.pickUpTime
                cell.callButton.addTarget(self, action: #selector(self.call(_:)), for: .touchUpInside)
                
                DispatchQueue.main.async(execute: { () -> Void in
                    let lineWidth = CGFloat(7.0)
                    let rect = CGRect(x: 0, y: 0.0, width: 50, height: 54)
                    let sides = 6
                    
                    let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 5.0, rotationOffset: CGFloat(.pi / 2.0))
                    
                    let borderLayer = CAShapeLayer()
                    borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
                    borderLayer.path = path.cgPath
                    borderLayer.lineWidth = lineWidth
                    borderLayer.lineJoin = kCALineJoinRound
                    borderLayer.lineCap = kCALineCapRound
                    borderLayer.strokeColor = UIColor.black.cgColor
                    borderLayer.fillColor = UIColor.white.cgColor
                    
                    let hexagon = createImage(layer: borderLayer)
                    
                    cell.profileImage.contentMode = .scaleAspectFill
                    cell.profileImage.layer.masksToBounds = false
                    cell.profileImage.layer.mask = borderLayer
                    cell.profileImage.image = self.userProfile
                })
            }
            else{
                cell.callButton.isHidden = true
                cell.ratingStar.isHidden = true
                cell.takenByLabel.isHidden = true
                cell.dropOffTimeLabel.isHidden = true
                cell.pickUpTimeLabel.isHidden = true
                cell.availableLabel.isHidden = false
                cell.nameLabel.isHidden = true
                cell.phoneLabel.isHidden = true
                cell.ratingLabel.isHidden = true
                cell.profileImage.isHidden = true
                cell.deleteButton.isHidden = false
                cell.deleteLabel.isHidden = false
                cell.deleteButton.addTarget(self, action: #selector(self.deleteListing(_:)), for: .touchUpInside)
                cell.editListingButton.isHidden = false
                cell.editListingLabel.isHidden = false
                cell.editListingButton.addTarget(self, action: #selector(self.editListing(_:)), for: .touchUpInside)
                
                
            }
        }

        
        myListingTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 27
        //shadows
        let shadowPath2 = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 30)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 2, height: 8)
        cell.layer.shadowOpacity = 0.025
        cell.layer.shadowPath = shadowPath2.cgPath
        cell.cellView.layer.cornerRadius = 27
        cell.layer.borderWidth = 0.5
        let borderColor = UIColor(red:0.58, green:0.41, blue:0.90, alpha: 0.8)
        cell.layer.borderColor = borderColor.cgColor
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.exists)!{
            myListingTableView.isHidden = false
            self.noCurrentListing.isHidden = true
            return 1
        }
        myListingTableView.isHidden = true
        self.noCurrentListing.isHidden = false
        return 0
    }
    
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newActivityIndicator.center = self.view.center
        newActivityIndicator.hidesWhenStopped = true
        newActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(newActivityIndicator)
        
        newActivityIndicator.startAnimating()
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        myListingView.addGestureRecognizer(swipeLeft)
        
        myListingTableView.delegate = self
        myListingTableView.dataSource = self
        self.exists = false
        findListings()

        // Do any additional setup after loading the view.
    }
    
    @objc func backSwipe(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath{
            selectedIndexPath = nil
        }
        else{
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<IndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
        }
        if let current = selectedIndexPath{
            indexPaths += [current]
        }
        if indexPaths.count > 0{
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! providerMyListingCellTableViewCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! providerMyListingCellTableViewCell).ignoreFrameChanges()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return providerMyListingCellTableViewCell.expandedHeight
        }
        else{
            return providerMyListingCellTableViewCell.defaultHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in myListingTableView.visibleCells as! [providerMyListingCellTableViewCell] {
            cell.ignoreFrameChanges()
        }
        
    }
    
    //makes animations synchronous
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    //hides the footer/creates space between sections
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func findListings(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Providers").child(uid!).child("currentStorage").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                for userChild in snapshot.children{
                    let userSnapshot = userChild as! DataSnapshot
                    let storageID = userSnapshot.key
                    if let dictionary = userSnapshot.value as? [String:Any?]{
                        print("MY LIST DICTIONARY", dictionary)
                        let tempAddress = dictionary["Address"] as? String
                        let fontAddress:UIFont? = UIFont(name: "Dosis-Medium", size:16)
                        let addressAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempAddress!, attributes: [.font: fontAddress!])
                        self.address = addressAttString
                        print(self.address)
                        
                        
                        let priceString = String(describing: dictionary["Price"]!!)
                        if let outputPrice = (Float(priceString)){
                            let finalPrice = Int(round(outputPrice))
                            var finalPriceRoundedString = "$ "
                            finalPriceRoundedString += String(describing: finalPrice)
                            finalPriceRoundedString += " /mo"
                            let font:UIFont? = UIFont(name: "Dosis-Bold", size:24)
                            let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                            let fontSmall:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                            
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: finalPriceRoundedString, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:0,length:1))
                            attString.setAttributes([.font:fontSmall!,.baselineOffset:-1], range: NSRange(location:(finalPriceRoundedString.count)-3,length:3))
                            self.price = attString
                            
                        }
                        var dimensionsString = String(describing: dictionary["Length"]!!)
                        dimensionsString += "' X "
                        dimensionsString += String(describing: dictionary["Width"]!!)
                        dimensionsString += "'"
                        let dimensionsTemp = dimensionsString
                        // maybe change this
                        let fontDimensions: UIFont? = UIFont(name: "Dosis-Bold", size:16)
                        let dimensionsAttString:NSMutableAttributedString = NSMutableAttributedString(string: dimensionsTemp, attributes: [.font: fontDimensions!])
                        self.dimensions = dimensionsAttString
                        
                        var cubicFeetNumber = Int(String(describing:dictionary["Length"]!!))
                        cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Width"]!!))!)
                        cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Height"]!!))!)
                        var cubicFeetString = String(describing: cubicFeetNumber!)
                        cubicFeetString += " ft3"
                        
                        let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                        let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                        
                        let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: cubicFeetString, attributes: [.font:font!])
                        cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:(cubicFeetString.count)-1,length:1))
                        
                        self.cubicFeet = cubicFeetAttString
                        self.newActivityIndicator.stopAnimating()
                    }
                    
                    
                    self.taken = false
                    self.exists = true
                    
                    
                }
                
            }
            else{
                self.newActivityIndicator.stopAnimating()
            }
        }, withCancel: nil)

        Database.database().reference().child("Providers").child(uid!).child("storageInUse").observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                for userChild in snapshot.children{
                    let userSnapshot = userChild as! DataSnapshot
                    let storageID = userSnapshot.key
                    if let dictionary = userSnapshot.value as? [String:Any?]{
                    print("MY LIST DICTIONARY", dictionary)
                        let tempAddress = dictionary["Address"] as? String
                        let fontAddress:UIFont? = UIFont(name: "Dosis-Medium", size:16)
                        let addressAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempAddress!, attributes: [.font: fontAddress!])
                        self.address = addressAttString
                        print(self.address)
                        
                        
                        let priceString = String(describing: dictionary["Price"]!!)
                        if let outputPrice = (Float(priceString)){
                            let finalPrice = Int(round(outputPrice))
                            var finalPriceRoundedString = "$ "
                            finalPriceRoundedString += String(describing: finalPrice)
                            finalPriceRoundedString += " /mo"
                            let font:UIFont? = UIFont(name: "Dosis-Bold", size:24)
                            let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                            let fontSmall:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                            
                            let attString:NSMutableAttributedString = NSMutableAttributedString(string: finalPriceRoundedString, attributes: [.font:font!])
                            attString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:0,length:1))
                            attString.setAttributes([.font:fontSmall!,.baselineOffset:-1], range: NSRange(location:(finalPriceRoundedString.count)-3,length:3))
                            self.price = attString
                            
                        }
                        var dimensionsString = String(describing: dictionary["Length"]!!)
                        dimensionsString += "' x "
                        dimensionsString += String(describing: dictionary["Width"]!!)
                        dimensionsString += "'"
                        let dimensionsTemp = dimensionsString
                        // maybe change this
                        let fontDimensions: UIFont? = UIFont(name: "Dosis-Bold", size:16)
                        let dimensionsAttString:NSMutableAttributedString = NSMutableAttributedString(string: dimensionsTemp, attributes: [.font: fontDimensions!])
                        self.dimensions = dimensionsAttString
                        
                        var cubicFeetNumber = Int(String(describing:dictionary["Length"]!!))
                        cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Width"]!!))!)
                        cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Height"]!!))!)
                        var cubicFeetString = String(describing: cubicFeetNumber!)
                        cubicFeetString += " ft3"

                        let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                        let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)

                        let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: cubicFeetString, attributes: [.font:font!])
                        cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:(cubicFeetString.count)-1,length:1))

                        self.cubicFeet = cubicFeetAttString
                        
                        if let timeDictionary = dictionary["time"] as? [String: Any]{
                            let tempTime = timeDictionary["time"] as? String
//                            let tempPickUp = timeDictionary["pickUpTime"] as? String
                            let timeFont:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                            let timeAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempTime!, attributes: [.font: timeFont!])
//                            let pickUpAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempPickUp!, attributes: [.font: timeFont!])
//                            self.dropOffTime = dropOffAttString
//                            self.pickUpTime = pickUpAttString
                            self.time = timeAttString
                        }
                        
                        
                        
                        let connectorID = dictionary["Connector"]!! as? String
                        self.getConnectorInfo(connectorID: connectorID!)
                    }

                    
                    self.taken = true
                    self.exists = true
                    
                    
                }
                
            }
        }, withCancel: nil)
    }
    
    func getConnectorInfo(connectorID: String){
        print(connectorID)
        Database.database().reference().child("Users").child(connectorID).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists(){
                    if let dictionary = snapshot.value as? [String:Any?]{
                        print("MY LIST DICTIONARY", dictionary)
                        let tempName = dictionary["name"] as? String
                        let fontName:UIFont? = UIFont(name: "Dosis-Bold", size:20)
                        let nameAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempName!, attributes: [.font: fontName!])
                        self.name = nameAttString
                        
                        
                        
                        let ratingString = String(describing: dictionary["rating"]!!)
                        let roundedRating = (Double(ratingString)! * 100).rounded()/100
                        let fontRating:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                        let tempRating = String(format: "%.2f", roundedRating)
                        let ratingAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempRating, attributes: [.font: fontRating!])
                        self.rating = ratingAttString
                        
                        
                        let tempPhone = dictionary["phone"] as? String
                        self.phoneRaw = tempPhone
                        let fontPhone:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                        let phoneAttString:NSMutableAttributedString = NSMutableAttributedString(string: tempPhone!, attributes: [.font: fontPhone!])
                        self.phone = phoneAttString
                        
                        
                        
                        URLSession.shared.dataTask(with: NSURL(string: dictionary["profilePicture"]!! as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                            if error != nil {
                                print(error)
                                return
                            }
                            DispatchQueue.main.async(execute: { () -> Void in
                                self.userProfile = UIImage(data: data!)
                            })
                            
                        }).resume()
                        
                    }
                
            }
        }, withCancel: nil)
    }
    
    @objc func call(_ sender:UIButton){
        print("CALLING")
        if let url = URL(string: "tel://\(String(describing: self.phoneRaw!))") {
            UIApplication.shared.open(url)
        }
    }
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func deleteListing(_ sender:UIButton){
        if let uid = Auth.auth().currentUser?.uid{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let providerReference = databaseReference.root.child("Providers").child(uid).child("currentStorage")
            
            databaseReference.root.child("Providers").child(uid).child("currentStorage").observe(.value, with: { (snapshot) in
//                print(snapshot)
                for userChild in snapshot.children{
                    let userSnapshot = userChild as! DataSnapshot
                    let storageID = userSnapshot.key
                    if let dictionary = userSnapshot.value as? [String:Any?]{
                        let connectDictionary = dictionary["potentialConnects"] as? [String: Any]
                        print("POTENTIAL CONNECTS", connectDictionary)
                        print("POTENTIAL CONNECTS 2", dictionary["potentialConnects"])
                        for potentialConnect in (connectDictionary?.keys)!{
                            let userReference = databaseReference.root.child("Users").child(potentialConnect)
                            userReference.child("pendingStorage").child(storageID).removeValue()
                        }
                    }
                        
                }
            })

            providerReference.removeValue()

        
            self.exists = false
            self.myListingTableView.reloadData()
        }
    }
    
    
    @objc func editListing(_ sender:UIButton){
        print("editListing")
        performSegue(withIdentifier: "editListingSegue", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editListingSegue"{
            var newActivityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
            newActivityIndicator.center = self.view.center
            newActivityIndicator.hidesWhenStopped = true
            newActivityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(newActivityIndicator)
            let destinationController = segue.destination as! addListingViewController
            if let user = Auth.auth().currentUser{
                Database.database().reference().child("Providers").child(user.uid).child("currentStorage").observe(.childAdded, with: { (snapshot) in
                    let currentStorageID = snapshot.key
                    destinationController.uniqueStorageID = currentStorageID
                    if let dictionary = snapshot.value as? [String: Any]{
                        destinationController.descriptionLabel.text = dictionary["Subtitle"] as! String
                        


                        var cubicFeetNumber = Int(String(describing:dictionary["Length"]!))
                        cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Width"]!))!)
                        cubicFeetNumber = cubicFeetNumber! * (Int(String(describing:dictionary["Height"]!))!)
                        var cubicFeetString = String(describing: cubicFeetNumber!)
                        cubicFeetString += " ft3"
                        
                        let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
                        let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
                        
                        let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: cubicFeetString, attributes: [.font:font!])
                        cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:(cubicFeetString.count)-1,length:1))
                        destinationController.savedCubicFeetLabel.attributedText = cubicFeetAttString

                        
                        
                        destinationController.savedCubicFeetLabel.isHidden = false
                        var dimensionsFinalString = String(describing: dictionary["Length"]!)
                        dimensionsFinalString += ("' x ")
                        dimensionsFinalString += String(describing: dictionary["Width"]!)
                        dimensionsFinalString += ("'")
                        
                        let fontDimensions: UIFont? = UIFont(name: "Dosis-Bold", size:16)
                        let dimensionsAttString:NSMutableAttributedString = NSMutableAttributedString(string: dimensionsFinalString, attributes: [.font: fontDimensions!])
                        
                        destinationController.savedDimensionsLabel.attributedText = dimensionsAttString
                        destinationController.savedDimensionsLabel.isHidden = false
                        destinationController.placeHolderDimensionsLabel.isHidden = true
                        destinationController.dimensionsErrorLabel.isHidden = true
                        
                        
                        //Photos
                        if let photoDictionary = dictionary["Photos"] as? [String: Any] {
                            print("PHOTO DICT FROM DATABASE", photoDictionary)
                            var editPhotoDictionary = [String: UIImage]()
                            
                            let sortedKeys = photoDictionary.keys.sorted()
                            
                            for (index, featureSorted) in sortedKeys.enumerated(){
                                let feature = photoDictionary[featureSorted]
                                URLSession.shared.dataTask(with: NSURL(string: feature as! String)! as URL, completionHandler: { (data, response, error) -> Void in
                                    
                                    if error != nil {
                                        print(error)
                                        return
                                    }
                                    DispatchQueue.main.async(execute: { () -> Void in
                                        let myImage = UIImage(data: data!)
                                        let myImageView:UIImageView = UIImageView()
                                        myImageView.frame.size.width = self.view.bounds.size.width
                                        myImageView.frame.origin.x = CGFloat(index) * self.view.bounds.size.width
                                        myImageView.image = myImage
                                        
                                        
                                        editPhotoDictionary[String(describing: index)] = myImage
                                        destinationController.addImagesDictionary = editPhotoDictionary
                                        destinationController.reloadAddImages()
                                        print("EDIT PHOTO DICTIONARY SEGUE", editPhotoDictionary)
                                    })
                                    
                                }).resume()
                            }
                        }
                        
                        self.newActivityIndicator.stopAnimating()

                    }
                }, withCancel: nil)
            }
//            let user = self.myListUsers[buttonIndexPath!]
//            destinationController.providerID = user.providerID
//            //            destinationController.providerAddress = user.address
//            destinationController.storageID = user.storageID
//
//            let locationManager = CLLocationManager()
//
//            destinationController.userLocation = locationManager.location
//            destinationController.providerLocation = user.providerLocation
            
            
        }
        
    }
}

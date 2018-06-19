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
    var myListing = myListingObject()
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
                cell.moreImage.image = UIImage(named: "Expand Arrow")
            }
            else
            {
                print (cell.contentView.bounds.size.height)
                cell.moreImage.image = UIImage(named: "Up Arrow")
            }
            
            if taken!{
                cell.availableLabel.isHidden = true
                cell.nameLabel.attributedText = self.name
                cell.phoneLabel.attributedText = self.phone
                cell.ratingLabel.attributedText = self.rating
                cell.deleteButton.isHidden = true
                cell.editDetailsButton.isHidden = true
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
                cell.availableLabel.isHidden = false
                cell.nameLabel.isHidden = true
                cell.phoneLabel.isHidden = true
                cell.ratingLabel.isHidden = true
                cell.profileImage.isHidden = true
                
                
            }
        }

        
        myListingTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 27
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if (self.exists)!{
            return 1
        }
        return 0
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myListingTableView.delegate = self
        myListingTableView.dataSource = self
        self.exists = false
        findListings()

        // Do any additional setup after loading the view.
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
                    }
                    
                    
                    self.taken = false
                    self.exists = true
                    
                    
                }
                
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
}

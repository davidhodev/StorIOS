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
    
    
    
    @IBOutlet weak var myListingTableView: UITableView!
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addListingButton(_ sender: Any) {
        performSegue(withIdentifier: "addListingSegue", sender: self)
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
            if taken!{
                cell.availableLabel.isHidden = true
                
            }
            else{
                cell.availableLabel.isHidden = false
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
                        
                        
                    }

                    
                    self.taken = true
                    self.exists = true
                    
                    
                }
                
            }
        }, withCancel: nil)
    }
    
}

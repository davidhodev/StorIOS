//
//  myStorageViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/29/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class myStorageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedIndexPath: IndexPath?
    var myStorageUsers = [myStorageUser]()
    var myCurrentStorageUsers = [myCurrentUser]()
    var selectorIndex: Int?
    

    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var currentNoFill: UIImageView!
    @IBOutlet weak var pendingNoFill: UIImageView!
    @IBOutlet weak var pendingFill: UIImageView!
    @IBOutlet weak var currentFill: UIImageView!
    @IBOutlet weak var currentIsEmpty: UILabel!
    
    @IBAction func switchCustomTableViewAction(_ sender: Any) {
        selectorIndex = switchCustomTable.selectedSegmentIndex
  
        
        // switch between current and past images
        if selectorIndex == 0{
            currentFill.isHidden = true
            pendingNoFill.isHidden = true
            pendingFill.isHidden = false
            currentNoFill.isHidden = false
            pendingLabel.textColor = UIColor(red:0.27, green:0.47, blue:0.91, alpha:1.0)
            currentLabel.textColor = UIColor.white
            
            
            
        }
        else{
            currentFill.isHidden = false
            pendingNoFill.isHidden = false
            pendingFill.isHidden = true
            currentNoFill.isHidden = true
            pendingLabel.textColor = UIColor.white
            currentLabel.textColor =  UIColor(red:0.27, green:0.47, blue:0.91, alpha:1.0)
        }
        
        DispatchQueue.main.async {
            self.storageTableView.reloadData()
        }
    }
    @IBOutlet weak var storageTableView: UITableView!
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var switchCustomTable: UISegmentedControl!
    @IBOutlet weak var myStorageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageTableView.delegate = self
        storageTableView.dataSource = self
        selectorIndex = 0
        let font = UIFont(name: "Dosis-Medium", size: 24.0)
        myStorageLabel.attributedText = NSMutableAttributedString(string: "My Storage", attributes: [.font:font!])
        currentFill.isHidden = true
        pendingNoFill.isHidden = true
        pendingFill.isHidden = false
        currentNoFill.isHidden = false
        getMyStorage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectorIndex == 0{
            if myStorageUsers.count == 0{
                self.storageTableView.isHidden = true
                self.currentIsEmpty.isHidden = false
            }
            else{
                self.storageTableView.isHidden = false
                self.currentIsEmpty.isHidden = true
            }
            return myStorageUsers.count
        }
        else{
            if myCurrentStorageUsers.count == 0{
                self.storageTableView.isHidden = true
                self.currentIsEmpty.isHidden = false
            }
            else{
                self.storageTableView.isHidden = false
                self.currentIsEmpty.isHidden = true
            }

            return myCurrentStorageUsers.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = storageTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! myStorageCustomTableViewCell
        let shadowPath2 = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 25)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor(red:0.27, green:0.29, blue:0.36, alpha:1.0).cgColor
        cell.layer.shadowOffset = CGSize(width: CGFloat(2), height: CGFloat(14.0))
        cell.layer.shadowOpacity = 0.0275
        cell.layer.shadowPath = shadowPath2.cgPath
        cell.layer.cornerRadius = 27
        cell.cellView.layer.cornerRadius = 27
        if selectorIndex == 0{
            let user = myStorageUsers[indexPath.section]
            // hiding and showing the buttons on pending section
            cell.cancelConnectionButton.isHidden = false
            cell.reportIssueButton.isHidden = true
            cell.schedulePickupButton.isHidden = true
            cell.reportIssueLabel.isHidden = true
            cell.schedulePickupLabel.isHidden = true
            
            cell.addressLabel.attributedText = user.address
            
            cell.priceLabel.attributedText = user.price
            cell.dimensionsLabel.attributedText = user.dimensionsString
            cell.cubicFeetLabel.attributedText = user.cubicString
            cell.nameLabel.attributedText = user.name
            cell.ratingLabel.attributedText = user.rating
            
            
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
                
                cell.providerProfileImage.contentMode = .scaleAspectFill
                cell.providerProfileImage.layer.masksToBounds = false
                cell.providerProfileImage.layer.mask = borderLayer
                cell.providerProfileImage.image = user.providerProfile
                cell.storagePhoto.image = user.storagePhoto
                
            })
            //changing image based on selection
            if (cell.contentView.bounds.size.height.rounded() == 60){
                cell.moreImage.image = UIImage(named: "Expand Arrow")
            }
            else
            {
                print (cell.contentView.bounds.size.height)
                cell.moreImage.image = UIImage(named: "Up Arrow")
            }
            
            cell.cancelConnectionButton.tag = indexPath.section
            print(cell.cancelConnectionButton.tag)
            cell.cancelConnectionButton.addTarget(self, action: #selector(self.cancelConnection(_:)), for: .touchUpInside)
            cell.callButton.tag = indexPath.section
            cell.callButton.addTarget(self, action: #selector(self.call(_:)), for: .touchUpInside)
            cell.reportIssueButton.addTarget(self, action: #selector(self.reportIssue(_:)), for: .touchUpInside)
            cell.schedulePickupButton.tag = indexPath.section
            cell.schedulePickupButton.addTarget(self, action: #selector(self.schedulePickup(_:)), for: .touchUpInside)
            

            
            storageTableView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.white
            return cell
        }
        else{
            let user = myCurrentStorageUsers[indexPath.section]
            cell.addressLabel.text = user.address
            // hiding and showing buttons on current section
            cell.cancelConnectionButton.isHidden = true
            cell.schedulePickupButton.isHidden = false
            cell.reportIssueButton.isHidden = false
            cell.reportIssueLabel.isHidden = false
            cell.schedulePickupLabel.isHidden = false
            cell.priceLabel.attributedText = user.price
            cell.dimensionsLabel.attributedText = user.dimensionsString

            cell.cubicFeetLabel.attributedText = user.cubicString
            cell.nameLabel.attributedText = user.name
            cell.ratingLabel.attributedText = user.rating
            
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

                cell.providerProfileImage.contentMode = .scaleAspectFill
                cell.providerProfileImage.layer.masksToBounds = false
                cell.providerProfileImage.layer.mask = borderLayer
                cell.providerProfileImage.image = user.providerProfile
                cell.storagePhoto.image = user.storagePhoto

            })
            //changing image based on selection
            if (cell.contentView.bounds.size.height.rounded() == 60){
                cell.moreImage.image = UIImage(named: "Expand Arrow")
            }
            else
            {
                print (cell.contentView.bounds.size.height)
                cell.moreImage.image = UIImage(named: "Up Arrow")
            }


            storageTableView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.white
            return cell
        }
        
    }
    
    @objc func cancelConnection(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("My custom button action")

        if selectorIndex == 0{
            let providerID = myStorageUsers[buttonIndexPath].providerID
            let myStorageID = myStorageUsers[buttonIndexPath].storageID
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((user.uid))
                    userReference.child("pendingStorage").child(myStorageID!).removeValue()
                
                let providerReference = databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(myStorageID!).child("potentialConnects").child(user.uid)
                providerReference.removeValue()
                
            }
            
            
            //PUSH NOTIFICATION TO PROVIDER
                
                self.myStorageUsers.remove(at: buttonIndexPath)
                self.storageTableView.reloadData()
        }
        else{
            print(selectorIndex)
        }
    }
    
    @objc func call(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("call")
        
        if selectorIndex == 0{
            let providerID = myStorageUsers[buttonIndexPath].providerID
            if Auth.auth().currentUser != nil{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                databaseReference.root.child("Providers").child(providerID!).child("personalInfo").observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any]{
                        let phone = dictionary["phone"]
                        let providerPhone = String(describing: phone!)
                        if let url = URL(string: "tel://\(String(describing: providerPhone))") {
                            UIApplication.shared.open(url)
                        }
                    }
                })
            }
        }
        else{
            let providerID = myCurrentStorageUsers[buttonIndexPath].providerID
            if Auth.auth().currentUser != nil{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                databaseReference.root.child("Providers").child(providerID!).child("personalInfo").observe(.value, with: { (snapshot) in
                    print(snapshot)
                    if let dictionary = snapshot.value as? [String: Any]{
                        let phone = dictionary["phone"]
                        let providerPhone = String(describing: phone!)
                        if let url = URL(string: "tel://\(String(describing: providerPhone))") {
                            UIApplication.shared.open(url)
                        }
                    }
                })
            }
        }
    }
    @objc func reportIssue(_ sender:UIButton) {
        openUrl(urlStr: "http://www.google.com") // STOR HELP WEBSITE
    }
    func openUrl(urlStr:String!) {
        
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    @objc func schedulePickup(_ sender:UIButton) {
        print("Schedule Pickup") 
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
        (cell as! myStorageCustomTableViewCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! myStorageCustomTableViewCell).ignoreFrameChanges()
    }

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return myStorageCustomTableViewCell.expandedHeight
        }
        else{
            return myStorageCustomTableViewCell.defaultHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in storageTableView.visibleCells as! [myStorageCustomTableViewCell] {
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
    
    func getMyStorage(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).child("pendingStorage").observeSingleEvent(of: .value, with: { (snapshot) in
                for userChild in snapshot.children{
                    let userSnapshot = userChild as! DataSnapshot
                    print("USER SNAPSHOT: ", userSnapshot)
                    let dictionary = userSnapshot.value as? [String: Any?]
                    print("DICTIONARY: ", dictionary!)
                    let user = myStorageUser()
                    user.providerID = dictionary!["myListProvider0"] as? String
                    user.storageID = dictionary!["myListStorage0"] as? String
                    user.getAddress()
                    user.getData()
                    self.myStorageUsers.append(user)
                    
                    DispatchQueue.main.async {
                        self.storageTableView.reloadData()
                    }
                }
            }, withCancel: nil)
        
        
        Database.database().reference().child("Users").child(uid!).child("currentStorage").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                let dictionary = userSnapshot.value as? [String: String?]
                print("GET MY STORAGE DICTIONARY", dictionary)
                let user = myCurrentUser()
                user.providerID = dictionary!["myListProvider0"] as? String
                user.storageID = dictionary!["myListStorage0"] as? String
                user.getAddress()
                user.getData()
                self.myCurrentStorageUsers.append(user)
                
                DispatchQueue.main.async {
                    self.storageTableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
}

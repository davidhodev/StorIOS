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

class myStorageDataManager {
    
    static let shared = myStorageDataManager()
    var storageVC = myStorageViewController()
}

class myStorageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var selectedIndexPath: IndexPath?
    var myCurrentStorageUsers = [myCurrentUser]()
    var selectorIndex: Int?
    var confirmationAddress: String?
    var confirmationProviderID: String?
    var confirmationStorageID: String?
    
    @IBOutlet weak var pendingFill: UIImageView!
    @IBOutlet weak var currentIsEmpty: UILabel!

    @IBOutlet weak var storageTableView: UITableView!
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var myStorageLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myStorageDataManager.shared.storageVC = self
        storageTableView.delegate = self
        storageTableView.dataSource = self
        selectorIndex = 0
        let font = UIFont(name: "Dosis-Medium", size: 24.0)
        myStorageLabel.attributedText = NSMutableAttributedString(string: "My Storage", attributes: [.font:font!])
        getMyStorage()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
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
        cell.callButton.tag = indexPath.section
        cell.callButton.addTarget(self, action: #selector(self.call(_:)), for: .touchUpInside)
        if myCurrentStorageUsers.count > 0{
            print("MY CURRENT STORAGE USERS ARRAY", myCurrentStorageUsers)
            let user = myCurrentStorageUsers[indexPath.section]
            cell.addressLabel.text = user.address
            // hiding and showing buttons on current section
            cell.cancelConnectionButton.isHidden = true
            cell.cancelConnectionLabel.isHidden = true
            print("NAME", user.name)
            
            print(user.status!)
            if user.status! == "confirmDropoff" {
                cell.confirmDropoffLabel.isHidden = false
                cell.confirmDropoffButton.isHidden = false
                cell.confirmDropoffButton.tag = indexPath.section
                cell.confirmDropoffButton.addTarget(self, action: #selector(self.confirmDropoff(_:)), for: .touchUpInside)
                
                cell.schedulePickupButton.isHidden = true
                cell.schedulePickupLabel.isHidden = true
                
                cell.confirmPickupButton.isHidden = true
                cell.confirmPickupLabel.isHidden = true
                cell.cancelConnectionButton.isHidden = false
                cell.cancelConnectionLabel.isHidden = false
                cell.cancelConnectionButton.tag = indexPath.section
                cell.cancelConnectionButton.addTarget(self, action: #selector(self.cancelConnection(_:)), for: .touchUpInside)
            }
            else if user.status! == "schedulePickup" {
                cell.confirmDropoffLabel.isHidden = true
                cell.confirmDropoffButton.isHidden = true
                
                cell.schedulePickupButton.isHidden = false
                cell.schedulePickupLabel.isHidden = false
                cell.schedulePickupButton.tag = indexPath.section
                cell.schedulePickupButton.addTarget(self, action: #selector(self.schedulePickup(_:)), for: .touchUpInside)
                
                
                cell.confirmPickupButton.isHidden = true
                cell.confirmPickupLabel.isHidden = true
                cell.cancelConnectionButton.isHidden = true
                cell.cancelConnectionLabel.isHidden = true
            }
            else{
                cell.confirmDropoffLabel.isHidden = true
                cell.confirmDropoffButton.isHidden = true
                
                cell.schedulePickupButton.isHidden = true
                cell.schedulePickupLabel.isHidden = true
                
                cell.confirmPickupButton.isHidden = false
                cell.confirmPickupLabel.isHidden = false
                cell.confirmPickupButton.tag = indexPath.section
                
                cell.cancelConnectionButton.isHidden = true
                cell.cancelConnectionLabel.isHidden = true
                
                cell.confirmPickupButton.addTarget(self, action: #selector(self.confirmPickup(_:)), for: .touchUpInside)
                
            }
            
            
            
            
            
            cell.priceLabel.attributedText = user.price
            cell.dimensionsLabel.attributedText = user.dimensionsString
            cell.dropOffTimeLabel.attributedText = user.dropOffTime

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
        }


            storageTableView.backgroundColor = UIColor.clear
            cell.backgroundColor = UIColor.white
            return cell
        
    }
    
    @objc func cancelConnection(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("My custom button action")

        let providerID = myCurrentStorageUsers[buttonIndexPath].providerID
        let myStorageID = myCurrentStorageUsers[buttonIndexPath].storageID
        print("PROVIDER AND STORAGE ID", providerID, myStorageID)
        if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((user.uid))
                    userReference.child("currentStorage").removeValue()



//                let providerReference = databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(myStorageID!).child("storageInUse")
//                providerReference.removeValue()
            

            databaseReference.root.child("Providers").child(providerID!).child("storageInUse").child(myStorageID!).observeSingleEvent(of: .value, with: { (snapshot) in
                print("SNAPSHOT, ", snapshot)
                    if let tempSnapshotValue = snapshot.value as? [String : AnyObject]{
                        print("TEMP SNAPSHOT VALUE", tempSnapshotValue)
                    databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(myStorageID!).setValue(tempSnapshotValue)
                    databaseReference.child("Providers").child(providerID!).child("storageInUse").removeValue()
                    }
                })
//
            
//                 databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(myStorageID!).child("time").updateChildValues(["time": realConnect.dropOff])
//
//                 databaseReference.root.child("Providers").child(user.uid).child("st orageInUse").child(myStorageID!).updateChildValues(["Connector": realConnect.userID])
//
//                 databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(myStorageID!).updateChildValues(["status": "confirmDropOff"])


//            }

            // REMOVE FROM PAYMENT AREA
//            //PUSH NOTIFICATION TO PROVIDER
//
                self.myCurrentStorageUsers.remove(at: buttonIndexPath)
                self.storageTableView.reloadData()
//            print(selectorIndex)
        }
    }
    
    @objc func call(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("call")
        
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
    func openUrl(urlStr:String!) {
        
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
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

        
        Database.database().reference().child("Users").child(uid!).child("currentStorage").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                let dictionary = userSnapshot.value as? [String: String?]
                print("GET MY STORAGE DICTIONARY", dictionary)
                let user = myCurrentUser()
                user.providerID = dictionary!["myListProvider0"] as? String
                user.storageID = dictionary!["myListStorage"] as? String
                user.getAddress()
                user.getData()
                self.myCurrentStorageUsers.append(user)
                
                DispatchQueue.main.async {
                    self.storageTableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "confirmDropOffSegue"{
            let destinationController = segue.destination as! confirmDropoffViewController
            destinationController.address = self.confirmationAddress
            destinationController.providerID = self.confirmationProviderID
            destinationController.storageID = self.confirmationStorageID
            
        }
    }
    
    
    @objc func confirmDropoff(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        self.confirmationAddress = myCurrentStorageUsers[buttonIndexPath].address
        self.confirmationProviderID = myCurrentStorageUsers[buttonIndexPath].providerID
        self.confirmationStorageID = myCurrentStorageUsers[buttonIndexPath].storageID!
        performSegue(withIdentifier: "confirmDropOffSegue", sender: self)
    }
    @objc func schedulePickup(_ sender:UIButton) {
        print("Schedule Pickup")
    }
    @objc func confirmPickup(_ sender:UIButton) {
        print("Confirm Pickup")
    }
    func refreshUI() { DispatchQueue.main.async { self.storageTableView.reloadData() } }
}

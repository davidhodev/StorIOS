//
//  ProviderConnectionsViewController.swift
//  Stor
//
//  Created by David Ho on 6/14/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProviderConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedIndexPath: IndexPath?
    var potentialConnects = [providerPotentialUser]()
    var currentConnects = [providerPotentialUser]()
    var selectorIndex: Int?
    
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var switchProviderTable: UISegmentedControl!
    @IBOutlet weak var myConnectionsLabel: UILabel!
    @IBOutlet weak var noCurrentConnectionsLabel: UILabel!
    @IBOutlet weak var noPendingOptionsLabel: UILabel!
    
    
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var currentNoFill: UIImageView!
    @IBOutlet weak var pendingNoFill: UIImageView!
    @IBOutlet weak var pendingFill: UIImageView!
    @IBOutlet weak var currentFill: UIImageView!
    
    
    /*
     @IBOutlet weak var currentLabel: UILabel!
     @IBOutlet weak var pendingLabel: UILabel!
     @IBOutlet weak var currentNoFill: UIImageView!
     @IBOutlet weak var pendingNoFill: UIImageView!
     @IBOutlet weak var pendingFill: UIImageView!
     @IBOutlet weak var currentFill: UIImageView!
     @IBOutlet weak var currentIsEmpty: UILabel!
     
 */
    
    @IBAction func exitButton(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        selectorIndex = switchProviderTable.selectedSegmentIndex
        
        
        // switch between current and past images
        if selectorIndex == 0{
            currentFill.isHidden = true
            pendingNoFill.isHidden = true
            pendingFill.isHidden = false
            currentNoFill.isHidden = false
            pendingLabel.textColor = UIColor(red:0.58, green:0.41, blue:0.9, alpha:1.0)
            currentLabel.textColor = UIColor.white
            
            
            
        }
        else{
            currentFill.isHidden = false
            pendingNoFill.isHidden = false
            pendingFill.isHidden = true
            currentNoFill.isHidden = true
            pendingLabel.textColor = UIColor.white
            currentLabel.textColor =  UIColor(red:0.58, green:0.41, blue:0.9, alpha:1.0)
        }
        
        DispatchQueue.main.async {
            self.providerTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if selectorIndex == 0{
            if potentialConnects.count == 0{
                self.providerTableView.isHidden = true
                self.noPendingOptionsLabel.isHidden = false
                self.noCurrentConnectionsLabel.isHidden = true
            }
            else{
                self.providerTableView.isHidden = false
                self.noPendingOptionsLabel.isHidden = true
                self.noCurrentConnectionsLabel.isHidden = true
            }
            return potentialConnects.count
        }
        if currentConnects.count == 0{
            self.providerTableView.isHidden = true
            self.noPendingOptionsLabel.isHidden = true
            self.noCurrentConnectionsLabel.isHidden = false
            return 0
        }
        else{
            print("1")
            self.providerTableView.isHidden = false
            self.noPendingOptionsLabel.isHidden = true
            self.noCurrentConnectionsLabel.isHidden = true
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = providerTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! potentialConnectsTableViewCell
        cell.cellView.layer.cornerRadius = 27
        cell.callButton.tag = indexPath.section
        cell.callButton.addTarget(self, action: #selector(self.call(_:)), for: .touchUpInside)
        if selectorIndex == 0{
            let user = potentialConnects[indexPath.section]
            cell.nameLabel.attributedText = user.name
            cell.ratingLabel.attributedText = user.rating
            print("PHONE LABEL: ", user.phone)
            cell.phoneLabel.attributedText = user.phone
            
            
            
            
            
            
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
                cell.profileImage.image = user.providerProfile
                print(user.dropOff)
                cell.dropOffTime.text = user.dropOff
                
            })
            
            
            if (cell.contentView.bounds.size.height.rounded() == 60){
                cell.dropDownImage.image = UIImage(named: "Purple Expand Arrow")
            }
            else
            {
                print (cell.contentView.bounds.size.height)
                cell.dropDownImage.image = UIImage(named: "Purple Close arrow")
            }
            
            cell.declineButton.tag = indexPath.section
            cell.declineButton.addTarget(self, action: #selector(self.declineButton(_:)), for: .touchUpInside)
            cell.acceptButton.tag = indexPath.section
            cell.acceptButton.addTarget(self, action: #selector(self.acceptButton(_:)), for: .touchUpInside)
        }
        else{
            let user = currentConnects[indexPath.section]
            cell.nameLabel.attributedText = user.name
            cell.ratingLabel.attributedText = user.rating
            print("PHONE LABEL: ", user.phone)
            cell.phoneLabel.attributedText = user.phone
            
            cell.acceptLabel.isHidden = true
            cell.rejectLabel.isHidden = true
            
            
            
            print(user.status!)
            if user.status! == "confirmDropoff" {
                cell.confirmDropoffLabel.isHidden = false
                cell.confirmDropoffButton.isHidden = false
                cell.confirmDropoffButton.tag = indexPath.section
                cell.confirmDropoffButton.addTarget(self, action: #selector(self.confirmDropoff(_:)), for: .touchUpInside)
                
                
                cell.confirmPickupButton.isHidden = true
                cell.confirmPickupLabel.isHidden = true
                
                print("USER DROPOFF", user.dropOff)
                cell.dropOffTime.text = user.dropOff
            }
            
            else{
                if user.status! == "schedulePickup"{
                    cell.dropOffTime.text = "Pickup time not yet chosen"
                }
                else{
                    print("USER PICKUPTIME", user.pickupTime)
                    cell.dropOffTime.text = user.pickupTime
                }
                
                cell.confirmDropoffLabel.isHidden = true
                cell.confirmDropoffButton.isHidden = true
                
                
                cell.confirmPickupButton.isHidden = false
                cell.confirmPickupLabel.isHidden = false
                cell.confirmPickupButton.tag = indexPath.section
                cell.confirmPickupButton.addTarget(self, action: #selector(self.confirmPickup(_:)), for: .touchUpInside)
            }
            
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
                cell.profileImage.image = user.providerProfile
                print(user.dropOff)
                cell.dropOffTime.text = user.dropOff
                
            })
            
            
            if (cell.contentView.bounds.size.height.rounded() == 60){
                cell.dropDownImage.image = UIImage(named: "Purple Expand Arrow")
            }
            else
            {
                print (cell.contentView.bounds.size.height)
                cell.dropDownImage.image = UIImage(named: "Purple Close arrow")
            }
            
            cell.declineButton.tag = indexPath.section
            cell.declineButton.addTarget(self, action: #selector(self.declineButton(_:)), for: .touchUpInside)
            cell.acceptButton.tag = indexPath.section
            cell.acceptButton.addTarget(self, action: #selector(self.acceptButton(_:)), for: .touchUpInside)
        }
        
        
        providerTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 27
        return cell
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
        (cell as! potentialConnectsTableViewCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! potentialConnectsTableViewCell).ignoreFrameChanges()
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return potentialConnectsTableViewCell.expandedHeight
        }
        else{
            return potentialConnectsTableViewCell.defaultHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in providerTableView.visibleCells as! [potentialConnectsTableViewCell] {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentFill.isHidden = true
        pendingNoFill.isHidden = true
        pendingFill.isHidden = false
        currentNoFill.isHidden = false
        providerTableView.delegate = self
        providerTableView.dataSource = self
        noCurrentConnectionsLabel.isHidden = true
        noPendingOptionsLabel.isHidden = true
        selectorIndex = 0
        
        let font = UIFont(name: "Dosis-Medium", size: 24.0)
        myConnectionsLabel.attributedText = NSMutableAttributedString(string: "My Connections", attributes: [.font:font!])
        
        getConnections()
        DispatchQueue.main.async {
            self.providerTableView.reloadData()
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getConnections(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Providers").child(uid!).child("currentStorage").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                print("USER SNAPSHOT: ", userSnapshot.key)
                let storageID = userSnapshot.key
                
                let dictionary = userSnapshot.value as? [String: Any?]
//                print("DICTIONARY: ", dictionary!)
                if let potentialConnectsDictionary = dictionary!["potentialConnects"] as? [String: Any?]{
                    print("POTENTIAL CONNECTS DICT: ", potentialConnectsDictionary)
                    for potentials in (potentialConnectsDictionary.keys){
                        print("STORAGE ID: ", potentials)
                        print("================================")
                        let user = providerPotentialUser()
                        user.storageID = storageID
                        user.userID = potentials
                        user.getName()
    //                    user.getData()
                        self.potentialConnects.append(user)
                        
                    }
                }
            }
        }, withCancel: nil)
        
        Database.database().reference().child("Providers").child(uid!).child("storageInUse").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                print("USER SNAPSHOT: ", userSnapshot.key)
                let storageID = userSnapshot.key
                
                let dictionary = userSnapshot.value as? [String: Any?]
                print("DICTIONARY: ", dictionary!)
                let currentUser = dictionary!["Connector"]
                let user = providerPotentialUser()
                user.storageID = storageID
                user.userID = currentUser as! String
                user.getName()
                //                    user.getData()
                self.currentConnects.append(user)
            }
        }, withCancel: nil)
        
    }
    
    
    @objc func call(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("CALLING")
        
        if selectorIndex == 0{
            let providerID = potentialConnects[buttonIndexPath].userID
            if Auth.auth().currentUser != nil{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                databaseReference.root.child("Users").child(providerID!).observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any]{
                        let phone = dictionary["phone"]
                        let customerPhone = String(describing: phone!)
                        if let url = URL(string: "tel://\(String(describing: customerPhone))") {
                            UIApplication.shared.open(url)
                        }
                    }
                })
            }
        }
        else{
            let providerID = currentConnects[buttonIndexPath].userID
            if Auth.auth().currentUser != nil{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                databaseReference.root.child("Users").child(providerID!).observe(.value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any]{
                        let phone = dictionary["phone"]
                        let customerPhone = String(describing: phone!)
                        if let url = URL(string: "tel://\(String(describing: customerPhone))") {
                            UIApplication.shared.open(url)
                        }
                    }
                })
            }
        }
    }
    
    
    @objc func declineButton(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("My custom button action")
        
        if selectorIndex == 0{
            let userID = potentialConnects[buttonIndexPath].userID
            print("USERID: ", userID)
            let myStorageID = potentialConnects[buttonIndexPath].storageID
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let providerReference = databaseReference.root.child("Providers").child(user.uid).child("currentStorage").child(myStorageID!).child("potentialConnects").child(userID!)
                providerReference.removeValue()
                
                let userReference = databaseReference.root.child("Users").child(userID!)
                userReference.child("pendingStorage").child(myStorageID!).removeValue()
                
                
                self.potentialConnects.remove(at: buttonIndexPath)
                self.providerTableView.reloadData()
                
                
                
            }
            
            
            //PUSH NOTIFICATION TO PROVIDER
            
        }
        else{
            print(selectorIndex)
        }
    }
    
    @objc func acceptButton(_ sender:UIButton) {
        let buttonIndexPath = sender.tag
        print("My custom button action")
        
        if selectorIndex == 0{
            let userID = potentialConnects[buttonIndexPath].userID
            print("USERID: ", userID)
            let myStorageID = potentialConnects[buttonIndexPath].storageID
            let realConnect = potentialConnects[buttonIndexPath]
            
            
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                for removingConnects in potentialConnects{
                    
                    let removingID = removingConnects.userID
                    let providerReference = databaseReference.root.child("Providers").child(user.uid).child("currentStorage").child(myStorageID!).child("potentialConnects").child(removingID!)
                    providerReference.removeValue()
                    
                    let userReference = databaseReference.root.child("Users").child(removingID!)
                    userReference.child("pendingStorage").child(myStorageID!).removeValue()
                    
                }
            databaseReference.root.child("Providers").child(user.uid).child("currentStorage").child(myStorageID!).child("potentialConnects").removeValue()
                
                
                databaseReference.root.child("Providers").child(user.uid).child("currentStorage").child(myStorageID!).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let tempSnapshotValue = snapshot.value as? [String : AnyObject]{
                    
                databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(myStorageID!).setValue(tempSnapshotValue)
                databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(myStorageID!).child("time").updateChildValues(["time": realConnect.dropOff])
                    
                databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(myStorageID!).updateChildValues(["Connector": realConnect.userID])
                        
                databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(myStorageID!).updateChildValues(["status": "confirmDropOff"])
                    }
                })

            databaseReference.child("Providers").child(user.uid).child("currentStorage").removeValue()
                
                self.potentialConnects.removeAll()
                self.providerTableView.reloadData()

            }
            
            print(realConnect)
            // PUSH NOTIFICATION TO PROVIDER
            
        }
        else{
            print(selectorIndex)
        }
    }
    @objc func confirmDropoff(_ sender:UIButton) {
        print("confirm Drop Off")
    }
    
    @objc func confirmPickup(_ sender:UIButton) {
       if let user = Auth.auth().currentUser{
        Database.database().reference().child("Providers").child(user.uid).child("storageInUse").observe(.value, with: { (snapshot) in

            if let dictionary = snapshot.value as? [String: Any]{
                let status = String(describing: dictionary["status"]!)
                print(status)
                if status == "schedulePickup"{
                    let alert = UIAlertController(title: "Uh-oh", message: "Your connection has not yet scheduled a pickup. Please call them if something is wrong ", preferredStyle: .alert)
                    self.present(alert, animated: true, completion:{
                        alert.view.superview?.isUserInteractionEnabled = true
                        alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
                    })
                }
            }
        })
    }
    print("Confirm Pickup")
    }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }

    
}

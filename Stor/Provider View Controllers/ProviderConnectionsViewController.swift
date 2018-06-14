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
    var currentConnects = [providerCurrentUser]()
    var selectorIndex: Int?
    
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var switchProviderTable: UISegmentedControl!
    @IBOutlet weak var myConnectionsLabel: UILabel!
    @IBOutlet weak var noCurrentConnectionsLabel: UILabel!
    @IBOutlet weak var noPendingOptionsLabel: UILabel!
    
    
    
    
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        selectorIndex = switchProviderTable.selectedSegmentIndex
        
        
        // switch between current and past images
        if selectorIndex == 0{
//            currentFill.isHidden = true
//            pendingNoFill.isHidden = true
//            pendingFill.isHidden = false
//            currentNoFill.isHidden = false
//            pendingLabel.textColor = UIColor(red:0.27, green:0.47, blue:0.91, alpha:1.0)
//            currentLabel.textColor = UIColor.white
            
            
            
        }
        else{
//            currentFill.isHidden = false
//            pendingNoFill.isHidden = false
//            pendingFill.isHidden = true
//            currentNoFill.isHidden = true
//            pendingLabel.textColor = UIColor.white
//            currentLabel.textColor =  UIColor(red:0.27, green:0.47, blue:0.91, alpha:1.0)
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
            self.providerTableView.isHidden = false
            self.noPendingOptionsLabel.isHidden = true
            self.noCurrentConnectionsLabel.isHidden = true
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = providerTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! potentialConnectsTableViewCell
        print(potentialConnects.count)
        print(indexPath.section)
        let user = potentialConnects[indexPath.section]
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
            
            cell.profileImage.contentMode = .scaleAspectFill
            cell.profileImage.layer.masksToBounds = false
            cell.profileImage.layer.mask = borderLayer
            cell.profileImage.image = user.providerProfile
            
        })
        
        
        if (cell.contentView.bounds.size.height.rounded() == 60){
            cell.dropDownImage.image = UIImage(named: "Expand Arrow")
        }
        else
        {
            print (cell.contentView.bounds.size.height)
            cell.dropDownImage.image = UIImage(named: "Up Arrow")
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
//                print("USER SNAPSHOT: ", userSnapshot)
                let dictionary = userSnapshot.value as? [String: Any?]
//                print("DICTIONARY: ", dictionary!)
                let potentialConnectsDictionary = dictionary!["potentialConnects"] as? [String: Any?]
                print("POTENTIAL CONNECTS DICT: ", potentialConnectsDictionary)
                for potentials in (potentialConnectsDictionary?.keys)!{
                    print("STORAGE ID: ", potentials)
                    print("================================")
                    let user = providerPotentialUser()
                    user.userID = potentials
                    user.getName()
//                    user.getData()
                    self.potentialConnects.append(user)
                    
                }
            }
        }, withCancel: nil)
        
        Database.database().reference().child("Providers").child(uid!).child("inUseStorage").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                //                print("USER SNAPSHOT: ", userSnapshot)
                let dictionary = userSnapshot.value as? [String: Any?]
                //                print("DICTIONARY: ", dictionary!)
                let connectionDictionary = dictionary!["connection"] as? [String: Any?]
                print("POTENTIAL CONNECTS DICT: ", connectionDictionary)
                for potentials in (connectionDictionary?.keys)!{
                    print("STORAGE ID: ", potentials)
                    print("================================")
                    let user = providerPotentialUser()
                    user.userID = potentials
                    user.getName()
                    //                    user.getData()
                    self.potentialConnects.append(user)
                    
                }
            }
        }, withCancel: nil)
        
//
//        Database.database().reference().child("Users").child(uid!).child("currentStorage").observeSingleEvent(of: .value, with: { (snapshot) in
//            for userChild in snapshot.children{
//                let userSnapshot = userChild as! DataSnapshot
//                let dictionary = userSnapshot.value as? [String: String?]
//                print("GET MY STORAGE DICTIONARY", dictionary)
//                let user = myCurrentUser()
//                user.providerID = dictionary!["myListProvider0"] as? String
//                user.storageID = dictionary!["myListStorage0"] as? String
//                user.getAddress()
//                user.getData()
//                self.myCurrentStorageUsers.append(user)
//
//                DispatchQueue.main.async {
//                    self.storageTableView.reloadData()
//                }
//            }
//        }, withCancel: nil)
//    }
    }
    
}

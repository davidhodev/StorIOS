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
//    var currentConnects = []()
    var selectorIndex: Int?
    
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var switchProviderTable: UISegmentedControl!
    @IBOutlet weak var myConnectionsLabel: UILabel!
    
    
    
    
    
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
//            if myStorageUsers.count == 0{
//                self.storageTableView.isHidden = true
//                self.currentIsEmpty.isHidden = false
//            }
//            else{
//                self.storageTableView.isHidden = false
//                self.currentIsEmpty.isHidden = true
//            }
            return potentialConnects.count
        }
//        else{
//            if myCurrentStorageUsers.count == 0{
//                self.storageTableView.isHidden = true
//                self.currentIsEmpty.isHidden = false
//            }
//            else{
//                self.storageTableView.isHidden = false
//                self.currentIsEmpty.isHidden = true
//            }
//
//            return myCurrentStorageUsers.count
//        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = providerTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! potentialConnectsTableViewCell
        print(potentialConnects.count)
        print(indexPath.section)
        let user = potentialConnects[indexPath.section]
        cell.nameLabel.attributedText = user.name
        cell.ratingLabel.attributedText = user.rating
        cell.profileImage.image = user.providerProfile
        
        
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
        selectorIndex = 0
        
        let font = UIFont(name: "Dosis-Medium", size: 24.0)
        myConnectionsLabel.attributedText = NSMutableAttributedString(string: "My Connections", attributes: [.font:font!])
        
        getConnections()
        

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
                    DispatchQueue.main.async {
                        self.providerTableView.reloadData()
                    }
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

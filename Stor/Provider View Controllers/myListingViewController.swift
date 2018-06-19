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
        

        
        myListingTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 27
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myListingTableView.delegate = self
        myListingTableView.dataSource = self
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
            if snapshot.exists(){}
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
//                        self.potentialConnects.append(user)
                        
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
                //                print("DICTIONARY: ", dictionary!)
                let currentUser = dictionary!["Connector"]
                let user = providerPotentialUser()
                user.storageID = storageID
                user.userID = currentUser as! String
                user.getName()
                //                    user.getData()
//                self.currentConnects.append(user)
            }
        }, withCancel: nil)
    }
    
}

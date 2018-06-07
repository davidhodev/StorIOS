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
    
    @IBOutlet weak var storageTableView: UITableView!
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageTableView.delegate = self
        storageTableView.dataSource = self
        
        getMyStorage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return myStorageUsers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = storageTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! myStorageCustomTableViewCell
        let user = myStorageUsers[indexPath.section]
        cell.addressLabel.text = user.address
        
        storageTableView.backgroundColor = UIColor.clear
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
        Database.database().reference().child("Users").child(uid!).child("myList").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                let dictionary = userSnapshot.value as? [String: String?]
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
    }
}

//
//  myListViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/29/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class myListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedIndexPath: IndexPath?

    @IBOutlet weak var myListTableView: UITableView!
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myListTableView.delegate = self
        myListTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myListTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! myListCustomCell
        cell.addressLabel.text = "Test Title"
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
        (cell as! myListCustomCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! myListCustomCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return myListCustomCell.expandedHeight
        }
        else{
            return myListCustomCell.defaultHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in myListTableView.visibleCells as! [myListCustomCell] {
            cell.ignoreFrameChanges()
        }
        
    }
    
    func getMyList(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).child("myList").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String:Any] {
                    print(dictionary)
                }
            }, withCancel: nil)
    }
    
}

//
//  SettingsViewControllerFinal.swift
//  
//
//  Created by Cole Feldman on 5/31/18.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import FBSDKLoginKit

let cellID = "customCell"

//struct cellDataForSettings {
//    var openned: Bool?
//    var title: String?
//    var subtitles = [String]()
//}

class SettingsViewControllerFinal: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var settingsTableView: UITableView!
    @IBAction func ExitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    //logout
    @IBAction func logoutButton(_ sender: Any) {
        try!  Auth.auth().signOut()
        GIDSignIn.sharedInstance().signOut()
        let manager = FBSDKLoginManager()
        manager.logOut()
        print("signed out")
        if let vc = self.storyboard?.instantiateInitialViewController() {
            self.present(vc, animated: true, completion: nil)
            self.navigationController?.popToViewController(vc, animated: true)
        }
    }
    
    
//    var tableViewDataSettings = [cellDataForSettings]()
    var selectedIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
//        settingsTableView.backgroundColor = UIColor.clear
//        settingsTableView.sectionIndexBackgroundColor = UIColor.clear
//        tableViewDataSettings = [cellDataForSettings(openned: false, title: "Notifications", subtitles: ["Push Notifications", "Text Message"]), cellDataForSettings(openned: false, title: "Privacy Settings", subtitles: ["Allow Stor to Contact you for news and promotions", "Delete Account"])]
    }

    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! settingsCustomCellTableViewCell
        cell.titleLabel.text = "Test Title"
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
        (cell as! settingsCustomCellTableViewCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! settingsCustomCellTableViewCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return settingsCustomCellTableViewCell.expandedHeight
        }
        else{
            return settingsCustomCellTableViewCell.defaultHeight
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in settingsTableView.visibleCells as! [settingsCustomCellTableViewCell] {
            cell.ignoreFrameChanges()
        }
        
    }
    
}

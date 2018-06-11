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
let cellSpacingHeight: CGFloat = 30
// making structure that labels and data takes from
struct cellDataForSettings {
    var title: String?
    var subtitles = [String]()
}

class SettingsViewControllerFinal: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var settingsTableView: UITableView!
    //exit button back to the map
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
    
    // creating variables for the structure and selection
    var tableViewDataSettings = [cellDataForSettings]()
    var selectedIndexPath: IndexPath?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        tableViewDataSettings = [cellDataForSettings(title: "Notifications", subtitles: ["Push Notifications", "Text Message"]), cellDataForSettings(title: "Privacy Settings", subtitles: ["Allow Stor to Contact you for news and promotions", ""])]
    }
    
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    //gives each cell and its header properties
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingsTableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! settingsCustomCellTableViewCell
        // make this take in the full array items
        cell.titleLabel.text = tableViewDataSettings[indexPath.section].title
        cell.dropDownOne.text = tableViewDataSettings[indexPath.section].subtitles[0]
        cell.dropDownTwo.text = tableViewDataSettings[indexPath.section].subtitles[1]
        // change the look of cell
        settingsTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 30
        //shadows
        
        
        
        

        //changing the switches, if statement is second section
        if (indexPath.section == numberOfSections(in: settingsTableView) - 1){
            cell.textMessageControl.isHidden = true
            cell.storContactControl.isHidden = false
            cell.pushNotificationsControl.isHidden = true
            cell.deleteAccountButtonControl.isHidden = false
        }
        else{
            cell.textMessageControl.isHidden = false
            cell.pushNotificationsControl.isHidden = false
            cell.storContactControl.isHidden = true
            cell.deleteAccountButtonControl.isHidden = true
        }
        if (cell.contentView.bounds.size.height == 60){
            cell.moreImage.image = UIImage(named: "Expand Arrow")
        }
        else
        {
            cell.moreImage.image = UIImage(named: "Up Arrow")
        }
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
    // expands and contracts cells when pressed
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath{
            return settingsCustomCellTableViewCell.expandedHeight
        }
        else{
            return settingsCustomCellTableViewCell.defaultHeight
        }
    }
    //makes animations synchronous
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
   //hides the footer/creates space between sections
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in settingsTableView.visibleCells as! [settingsCustomCellTableViewCell] {
            cell.ignoreFrameChanges()
        }
        
    }
    
}

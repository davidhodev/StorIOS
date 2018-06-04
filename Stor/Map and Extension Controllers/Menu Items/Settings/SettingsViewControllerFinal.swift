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



struct cellDataForSettings {
    var openned: Bool?
    var title: String?
    var subtitles = [String]()
}

var selectedIndexPath: IndexPath?

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
    
    
    var tableViewDataSettings = [cellDataForSettings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.backgroundColor = UIColor.clear
        settingsTableView.sectionIndexBackgroundColor = UIColor.clear
        tableViewDataSettings = [cellDataForSettings(openned: false, title: "Notifications", subtitles: ["Push Notifications", "Text Message"]), cellDataForSettings(openned: false, title: "Privacy Settings", subtitles: ["Allow Stor to Contact you for news and promotions", "Delete Account"])]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == selectedIndexPath){
            return 200
        }
        else{
            return 60
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataIndex = indexPath.row - 1
//        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! settingsCustomCellTableViewCell
            cell.textLabel?.text = tableViewDataSettings[indexPath.section].title
            cell.dropDownOne?.text = tableViewDataSettings[indexPath.section].subtitles[0]
            cell.dropDownTwo?.text = tableViewDataSettings[indexPath.section].subtitles[1]
            cell.moreImage.image = UIImage(named: "Expand Arrow")
            cell.cellView.layer.cornerRadius = 27
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        
            return cell
//        }
//        else{
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "customCell") else{ return UITableViewCell()}
//            cell.textLabel?.text = tableViewDataSettings[indexPath.section].sectionData[dataIndex]
//            return cell
//        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    
        return CGFloat(10)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        
        selectedIndexPath = indexPath
        
        if indexPath.row == 0{
            if tableViewDataSettings[indexPath.section].openned == true{
                tableViewDataSettings[indexPath.section].openned = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else{
                tableViewDataSettings[indexPath.section].openned = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
    }
}

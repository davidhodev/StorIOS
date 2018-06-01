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
    var sectionData = [String]()
}



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
        self.dismiss(animated: false, completion: {})
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    var tableViewDataSettings = [cellDataForSettings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        tableViewDataSettings = [cellDataForSettings(openned: false, title: "My Profile", sectionData: [""]), cellDataForSettings(openned: false, title: "Location Settings", sectionData: [""]), cellDataForSettings(openned: false, title: "Notificantions", sectionData: ["Push Notifications", "Text Messages"]), cellDataForSettings(openned: false, title: "Privacy Settings", sectionData: ["Allow Stor to contact you for news and promotions", "Delete Account"])]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewDataSettings.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewDataSettings[section].openned == true{
            return tableViewDataSettings[section].sectionData.count + 1
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataIndex = indexPath.row - 1
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{ return UITableViewCell()}
            cell.textLabel?.text = tableViewDataSettings[indexPath.section].title
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{ return UITableViewCell()}
            cell.textLabel?.text = tableViewDataSettings[indexPath.section].sectionData[dataIndex]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

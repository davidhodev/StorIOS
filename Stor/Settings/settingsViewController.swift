//
//  SettingsViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/30/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class settingsViewController: UIViewController, UITableViewDelegate{ //UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 4
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
    

    @IBOutlet weak var settingsTable: settingsTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let notificationsButtonNames = ["Push Notifications", "Text Messages"]
        let privacyButtonNames = ["Allow STOR to contact you for news and promotions", "Delete Account"]
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  SettingsViewControllerFinal.swift
//  
//
//  Created by Cole Feldman on 5/31/18.
//

import UIKit
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
    
    var tableViewDataSettings = [cellDataForSettings]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        tableViewDataSettings = [cellDataForSettings(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"]), cellDataForSettings(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"]), cellDataForSettings(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"]), cellDataForSettings(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"])]
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

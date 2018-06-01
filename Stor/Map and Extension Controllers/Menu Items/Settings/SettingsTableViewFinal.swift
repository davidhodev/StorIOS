//
//  SettingsTableViewFinal.swift
//  Stor
//
//  Created by Cole Feldman on 5/31/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

struct cellData {
    var opened = Bool()
    var title = String()
    var sectionData = [String]()
}

class SettingsTableViewFinal: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableViewData = [cellData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewData = [cellData(opened: false, title: "Title1", sectionData: []),
                         cellData(opened: false, title: "Title2", sectionData: []),
                         cellData(opened: false, title: "Title3", sectionData: ["Cell1", "Cell2"]),
                         cellData(opened: false, title: "Title4", sectionData: ["Cell1", "Cell2"])]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].opened == true{
            return tableViewData[section].sectionData.count
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
   
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

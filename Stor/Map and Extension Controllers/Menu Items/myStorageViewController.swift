//
//  myStorageViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/29/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

struct cellDataForStorage {
    var openned: Bool?
    var title: String?
    var sectionData = [String]()
}


class myStorageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var storageTableView: UITableView!
    
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    var tableViewData = [cellDataForStorage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageTableView.delegate = self
        storageTableView.dataSource = self
        tableViewData = [cellDataForStorage(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"]), cellDataForStorage(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"]), cellDataForStorage(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"]), cellDataForStorage(openned: false, title: "Title1", sectionData: ["Cell1", "Cell2", "Cell3"])]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableViewData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewData[section].openned == true{
            return tableViewData[section].sectionData.count + 1
        }
        else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var dataIndex = indexPath.row - 1
        if indexPath.row == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{ return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].title
            return cell
        }
        else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else{ return UITableViewCell()}
            cell.textLabel?.text = tableViewData[indexPath.section].sectionData[dataIndex]
            return cell
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            if tableViewData[indexPath.section].openned == true{
                tableViewData[indexPath.section].openned = false
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
            else{
                tableViewData[indexPath.section].openned = true
                let sections = IndexSet.init(integer: indexPath.section)
                tableView.reloadSections(sections, with: .none)
            }
        }
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

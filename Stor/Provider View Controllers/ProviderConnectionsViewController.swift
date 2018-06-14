//
//  ProviderConnectionsViewController.swift
//  Stor
//
//  Created by David Ho on 6/14/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class ProviderConnectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var selectedIndexPath: IndexPath?
//    var potentialConnects = []()
//    var currentConnects = []()
    var selectorIndex: Int?
    
    @IBOutlet weak var providerTableView: UITableView!
    @IBOutlet weak var switchProviderTable: UISegmentedControl!
    @IBOutlet weak var myConnectionsLabel: UILabel!
    
    
    
    
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func segmentedControl(_ sender: Any) {
        selectorIndex = switchProviderTable.selectedSegmentIndex
        
        
        // switch between current and past images
        if selectorIndex == 0{
//            currentFill.isHidden = true
//            pendingNoFill.isHidden = true
//            pendingFill.isHidden = false
//            currentNoFill.isHidden = false
//            pendingLabel.textColor = UIColor(red:0.27, green:0.47, blue:0.91, alpha:1.0)
//            currentLabel.textColor = UIColor.white
            
            
            
        }
        else{
//            currentFill.isHidden = false
//            pendingNoFill.isHidden = false
//            pendingFill.isHidden = true
//            currentNoFill.isHidden = true
//            pendingLabel.textColor = UIColor.white
//            currentLabel.textColor =  UIColor(red:0.27, green:0.47, blue:0.91, alpha:1.0)
        }
        
        DispatchQueue.main.async {
            self.providerTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = providerTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! potentialConnectsTableViewCell
        
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        providerTableView.delegate = self
        providerTableView.dataSource = self
        
        let font = UIFont(name: "Dosis-Medium", size: 24.0)
        myConnectionsLabel.attributedText = NSMutableAttributedString(string: "My Connections", attributes: [.font:font!])
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

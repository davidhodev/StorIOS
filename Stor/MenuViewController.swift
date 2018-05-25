//
//  MenuViewController.swift
//  Stor
//
//  Created by Cole Feldman on 5/24/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class MenuViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func exitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test1")
        self.nameLabel.text = globalVariablesViewController.username


        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

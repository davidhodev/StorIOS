//
//  TermsViewController.swift
//  Stor
//
//  Created by Cole Feldman on 5/23/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class TermsViewController: UIViewController {
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
        
}


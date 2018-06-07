//
//  filterViewController.swift
//  Stor
//
//  Created by Jack Feldman on 6/6/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class filterViewController: UIViewController {

    @IBOutlet weak var sizeRangeSlider: RangeSlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bigDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
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

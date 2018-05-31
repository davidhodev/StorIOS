//
//  AnnotationPopUp.swift
//  Stor
//
//  Created by Cole Feldman on 5/30/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseDatabase



class AnnotationPopUp: UIViewController {

    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerRatingLabel: UILabel!
    @IBOutlet weak var providerDescriptionLabel: UILabel!
    @IBOutlet weak var providerAddressLabel: UILabel!
    @IBOutlet weak var providerDistanceLabel: UILabel!
    @IBOutlet weak var providerPriceLabel: UILabel!
    @IBOutlet weak var providerSizeLabel: UILabel!
    
    
    var providerAddress: String?
    var providerID: String?
    var storageID: String?
    
    @IBAction func Exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Providers").child(providerID!).child("currentStorage").observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                self.providerAddressLabel.text = dictionary["Address"] as! String
                self.providerNameLabel.text = dictionary["Name"] as! String
                self.providerDescriptionLabel.text = dictionary["Subtitle"] as! String
                
            }
        }, withCancel: nil)
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

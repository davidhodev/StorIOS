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

    var providerAddress: String?
    var providerID: String?
    @IBAction func Exit(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(providerID)
        Database.database().reference().child("Providers").child(providerID!).observe(.childAdded, with: { (snapshot) in
//            print(snapshot)
            print(snapshot.value)
            if let dictionary = snapshot.value as? [String: Any]{
                print("SUBTITLE TEST", dictionary["Subtitle"] as! String)
                let providerAddress = (dictionary["Address"] as! String)
            }
        })
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

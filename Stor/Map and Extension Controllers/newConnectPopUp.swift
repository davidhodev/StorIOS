//
//  newConnectPopUp.swift
//  Stor
//
//  Created by Cole Feldman on 6/1/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class newConnectPopUp: UIViewController {
    
    @IBOutlet weak var date1Label: UILabel!
    @IBOutlet weak var date2Label: UILabel!
    @IBOutlet weak var date3Label: UILabel!
    @IBOutlet weak var time1Label: UILabel!
    @IBOutlet weak var time2Label: UILabel!
    @IBOutlet weak var time3Label: UILabel!
    @IBOutlet weak var slot1button: UIButton!
    var buttonActive = false
    
    @IBOutlet weak var slot2Button: UIButton!
    var buttonActive2 = false
    
    @IBOutlet weak var slot3button: UIButton!
    var buttonActive3 = false
    
    
    
    var timeSlotPressed: Int?
    var providerID: String?
    var storageID: String?

    // button function, changes color when pressed
    @IBAction func slot1ButtonPressed(_ sender: UIButton) {
        if buttonActive == false {
            slot1button.setImage(UIImage(named: "Blue Circle"), for: .normal)
            slot2Button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            slot3button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            buttonActive = true
            buttonActive2 = false
            buttonActive3 = false
        }
        else{
            slot1button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            buttonActive = false
        }
    }
    
    @IBAction func slot2ButtonPressed(_ sender: UIButton) {
        if buttonActive2 == false {
            slot2Button.setImage(UIImage(named: "Blue Circle"), for: .normal)
            slot1button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            slot3button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            buttonActive = false
            buttonActive2 = true
            buttonActive3 = false
        }
        else{
            slot2Button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            buttonActive2 = false
        }
    }
    @IBAction func slot3ButtonPressed(_ sender: Any) {

        if buttonActive3 == false {
            slot1button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            slot2Button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            slot3button.setImage(UIImage(named: "Blue Circle"), for: .normal)
            buttonActive = false
            buttonActive2 = false
            buttonActive3 = true
        }
        else{
            slot2Button.setImage(UIImage(named: "Grey Circle"), for: .normal)
            buttonActive3 = false
        }
    }
    
    
    //exit button full screen so that when you click off of the table of connect times, it takes you out 
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        print("submit")
        
        if let user = Auth.auth().currentUser{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let userReference = databaseReference.root.child("Users").child((user.uid))
            userReference.child("pendingStorage").child(self.storageID!).updateChildValues(["myListProvider0": self.providerID, "myListStorage0": self.storageID])
        }
        
//        if let user = Auth.auth().currentUser{
//            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
//
//            print(user.email)
//            print(user.uid)
//            let userReference = databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(storageID!)
//
//                userReference.child("potentialConnects").updateChildValues([user.email!: user.uid])
//
//        }
    }

    @IBAction func callProviderButtonpressed(_ sender: Any) {
        if Auth.auth().currentUser != nil{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            databaseReference.root.child("Providers").child(providerID!).child("personalInfo").observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: Any]{
                    let phone = dictionary["phone"]
                    let providerPhone = String(describing: phone!)
                    if let url = URL(string: "tel://\(String(describing: providerPhone))") {
                        UIApplication.shared.open(url)
                    }
                }
            })
        }
    }
    
    
    
    override func viewDidLoad() {
        if Auth.auth().currentUser != nil{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(storageID!).observe(.value, with: { (snapshot) in
                print(snapshot)
                if let dictionary = snapshot.value as? [String: Any]{
                    let timeDictionary = dictionary["times"] as? [String: Any]
                    print(timeDictionary!)
                    self.date1Label.text = Array(timeDictionary!.keys)[0]
                    self.date2Label.text = Array(timeDictionary!.keys)[1]
                    self.date3Label.text = Array(timeDictionary!.keys)[2]
                    
                    self.time1Label.text = Array(timeDictionary!.values)[0] as? String
                    self.time2Label.text = Array(timeDictionary!.values)[1] as? String
                    self.time3Label.text = Array(timeDictionary!.values)[2] as? String
                    
                }
            })
            
            
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

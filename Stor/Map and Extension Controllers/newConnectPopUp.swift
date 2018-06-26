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
    

    
    var timeDictionary: [String: Any]?
    var selectedButton = 3
    var timeSlotPressed: Int?
    var providerID: String?
    var storageID: String?
    @IBOutlet weak var timePicker: UITextField!
    let picker = UIDatePicker()
    
    func createDatePickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector((donePressed)))
        toolbar.setItems([done], animated: false)
        timePicker.inputAccessoryView = toolbar
        timePicker.inputView = picker
    }
    
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        
        //play around with this
        dateFormatter.dateFormat = "Month, Day, hour:minutes"
        timePicker.text = dateFormatter.string(from: picker.date)
        view.endEditing(true)
    }

    
    //exit button full screen so that when you click off of the table of connect times, it takes you out 
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        print("submit")
        if selectedButton == 3{
            print("NOTHING IS SELECTED")
            
            let alert = UIAlertController(title: "Uh-oh", message: "Please select one of the offered time slots", preferredStyle: .alert)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
        }
    }
//        else{
//
//            if let user = Auth.auth().currentUser{
//                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
//                let userReference = databaseReference.root.child("Users").child((user.uid))
//
//                var selectedTimeString = Array(self.timeDictionary!.keys)[selectedButton]
//                selectedTimeString += " "
//                selectedTimeString += (Array(self.timeDictionary!.values)[selectedButton] as? String)!
//                userReference.child("pendingStorage").child(self.storageID!).updateChildValues(["myListProvider0": self.providerID, "myListStorage0": self.storageID, "chosenTimeSlotNumber": selectedButton, "timeSlotString": selectedTimeString])
//
//
//                let providerReference = databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(storageID!)
//
//
//                providerReference.child("potentialConnects").child(user.uid).updateChildValues([user.uid: user.uid, "chosenTimeSlotNumber": selectedButton, "timeSlotString": selectedTimeString])
//
//                DataManager.shared.menuVC.viewDidLoad()
//
//                self.dismiss(animated: true, completion: nil)
//            }
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }


    
    
    override func viewDidLoad() {
        createDatePickerView()
//        if Auth.auth().currentUser != nil{
//            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
//            databaseReference.root.child("Providers").child(providerID!).child("currentStorage").child(storageID!).observe(.value, with: { (snapshot) in
//                print(snapshot)
//                if let dictionary = snapshot.value as? [String: Any]{
//                    self.timeDictionary = dictionary["times"] as? [String: Any]
//                    print(self.timeDictionary!)
//                    self.date1Label.text = Array(self.timeDictionary!.keys)[0]
//                    self.date2Label.text = Array(self.timeDictionary!.keys)[1]
//                    self.date3Label.text = Array(self.timeDictionary!.keys)[2]
//
//                    self.time1Label.text = Array(self.timeDictionary!.values)[0] as? String
//                    self.time2Label.text = Array(self.timeDictionary!.values)[1] as? String
//                    self.time3Label.text = Array(self.timeDictionary!.values)[2] as? String
//
//                }
//            })
//
//
//        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

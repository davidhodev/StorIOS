//
//  confirmPickupProviderViewController.swift
//  Stor
//
//  Created by Cole Feldman on 6/25/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class confirmPickupProviderViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var photoConfirmation: UIImageView!
    @IBOutlet weak var oneStar: UIButton!
    @IBOutlet weak var twoStar: UIButton!
    @IBOutlet weak var threeStar: UIButton!
    @IBOutlet weak var fourStar: UIButton!
    @IBOutlet weak var fiveStar: UIButton!
    
    
    var rating = 0.0
    var address: String?
    var userID: String?
    var storageID: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        photoConfirmation.contentMode = .scaleAspectFill
        photoConfirmation.layer.cornerRadius = 8
        photoConfirmation.layer.shadowOpacity = 0.07
        photoConfirmation.layer.shadowOffset = CGSize(width: CGFloat(0), height: CGFloat(10.0))
        
        photoConfirmation.image = UIImage(named: "Blank Photo")
        photoConfirmation.isUserInteractionEnabled = true
        photoConfirmation.layer.masksToBounds = true
        
        photoConfirmation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(chooseConfirmationPhoto)))
        // Do any additional setup after loading the view.
    }
    
    @objc func chooseConfirmationPhoto(){
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera){
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
            else{
                print("camera not available")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil ))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        photoConfirmation.image = image
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func exitButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func oneStarButton(_ sender: Any) {
        rating = 1
        self.oneStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.twoStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
        self.threeStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
        self.fourStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
        self.fiveStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
    }
    
    @IBAction func twoStarButton(_ sender: Any) {
        rating = 2
        self.oneStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.twoStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.threeStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
        self.fourStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
        self.fiveStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
    }
    
    @IBAction func threeStarButton(_ sender: Any) {
        rating = 3
        self.oneStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.twoStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.threeStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.fourStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
        self.fiveStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
    }
    
    @IBAction func fourStarButton(_ sender: Any) {
        rating = 4
        self.oneStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.twoStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.threeStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.fourStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.fiveStar.setImage(UIImage(named: "Grey Star"), for: UIControlState.normal)
    }
    
    @IBAction func fiveStarButton(_ sender: Any) {
        rating = 5
        self.oneStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.twoStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.threeStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.fourStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
        self.fiveStar.setImage(UIImage(named: "Gold Star"), for: UIControlState.normal)
    }
    @IBAction func submit(_ sender: Any) {
        if rating == 0 || photoConfirmation.image == UIImage(named: "Blank Photo"){
            let alert = UIAlertController(title: "Uh-oh", message: "Make sure you chose a rating and submit a photo for security references", preferredStyle: .alert)
            self.present(alert, animated: true, completion:{
                alert.view.superview?.isUserInteractionEnabled = true
                alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
            })
        }
        else{
            print("SUBMITTED")
            let imageUniqueID = self.address
            print(imageUniqueID)
            let storageRef = Storage.storage().reference().child("providerConfirmPickup").child("\(imageUniqueID!).jpeg")
            
            
            if let uploadData = UIImageJPEGRepresentation(self.photoConfirmation.image!, 0.1){
                
                storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                    if (error != nil){
                        print(error)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (updatedURL, error) in
                        if (error != nil){
                            print(error)
                            return
                        }
                    })
                })
            }
            
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((self.userID!))
                
                let providerReference = databaseReference.root.child("Providers").child(user.uid).child("storageInUse").child(self.storageID!)
               
                
                Database.database().reference().child("Providers").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any]{
                        let userStatus = dictionary["status"] as? String
                        if (userStatus == "done"){
                            //REMOVE
                            
                        }
                    }
                })
                providerReference.updateChildValues(["providerStatus": "done"])
                
                
                // New Rating
                userReference.observeSingleEvent(of: .value, with: { (snapshot) in
                    if let dictionary = snapshot.value as? [String: Any]{
                        let oldRating = dictionary["rating"] as? Double
                        var numberOfRatings = dictionary["numberOfRatings"] as? Double
                        var databaseRating = oldRating! * numberOfRatings!
                        databaseRating += self.rating
                        numberOfRatings! += 1
                        databaseRating = databaseRating / numberOfRatings!
                        userReference.updateChildValues(["rating": databaseRating, "numberOfRatings": numberOfRatings])
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                })
            }
        }
    }
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }

}

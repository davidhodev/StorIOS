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
import FirebaseStorage
import Firebase



class MenuViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var rating: UILabel!
    @IBAction func exitButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func menuHelpButton(_ sender: UIButton) {
        openUrl(urlStr: "http://www.google.com")
    }
    func openUrl(urlStr:String!) {
        
        if let url = NSURL(string:urlStr) {
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }
    }
    
    
    
    @IBAction func becomeProviderButton(_ sender: UIButton) {
        openUrl(urlStr: "http://www.google.com")
    }
    var activityIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Test1")
        self.nameLabel.text = globalVariablesViewController.username
        print("ralet sting", String(describing: globalVariablesViewController.ratingNumber))
        let outputRating2 = ((globalVariablesViewController.ratingNumber as! Double) * 100).rounded()/100
        self.rating.text = String(format: "%.2f",  outputRating2)
        
        //Hexagon SHape
        let lineWidth = CGFloat(7.0)
        let rect = CGRect(x: 0, y: 0.0, width: 90, height: 96)
        let sides = 6

        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 8.0, rotationOffset: CGFloat(.pi / 2.0))

        let borderLayer = CAShapeLayer()
        borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineCap = kCALineCapRound
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.white.cgColor

        _ = createImage(layer: borderLayer)
        
        
        
        profileImage.contentMode = .scaleAspectFill
//        profileImage.layer.cornerRadius = 20
        profileImage.layer.masksToBounds = false
        profileImage.layer.mask = borderLayer
//        profileImage.layer.addSublayer(borderLayer)
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        
        profileImage.loadProfilePicture()

        //Do any additional setup after loading the view.
    }
    

    
    // Creating Hexagon Shape for Profile Picture
    
    // What happens when Image is Pressed
    @objc func handleSelectImageView(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    // Finished Picking Photo
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImage: UIImage?
        if let edittedImage = info["UIImagePickerControllerEdittedImage"] as? UIImage {
            selectedImage = edittedImage
        }
        else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImage = originalImage
        }
        if let selectedImageFinal = selectedImage{
            profileImage.image = selectedImageFinal
        }
        let imageUniqueID = NSUUID().uuidString
        let storageRef = Storage.storage().reference().child("UserProfileImages").child("\(imageUniqueID).jpeg")
        
       
        if let uploadData = UIImageJPEGRepresentation(self.profileImage.image!, 0.1){

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
                    globalVariablesViewController.profilePicString = (updatedURL?.absoluteString)!
                    if let user = Auth.auth().currentUser{
                        let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                        let userReference = databaseReference.root.child("Users").child((user.uid))
                        print(userReference)
                        userReference.updateChildValues(["profilePicture": updatedURL?.absoluteString], withCompletionBlock: {(err, registerDataValues) in
                            if err != nil{
                                print(err)
                                return
                            }
                            print("Profile Pic Updated")
                            
                        })
                    }
                })
            })
        }
        dismiss(animated: true, completion: nil)
    }
    
    // Cancelled Picking Photo
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet var profileImageView: UIImageView!
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

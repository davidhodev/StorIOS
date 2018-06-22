//
//  providerMenuViewController.swift
//  Stor
//
//  Created by David Ho on 6/13/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class providerMenuPopup {
    static let shared = providerMenuPopup()
    var providerMenuVC = providerMenuViewController()
    
}

class providerMenuViewController: UIViewController {
    @IBOutlet weak var providerProfileImage: UIImageView!
    @IBOutlet weak var providerNameLabel: UILabel!
    @IBOutlet weak var providerRatingLabel: UILabel!
    
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func exitArea(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        providerMenuPopup.shared.providerMenuVC = self
        print(globalVariablesViewController.username)
        self.providerNameLabel.text = globalVariablesViewController.username

        if let user = Auth.auth().currentUser{
            Database.database().reference().child("Providers").child(user.uid).child("personalInfo").observe(.value, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any]{
                let ratingString = String(describing: dictionary["rating"]!)
                let roundedRating = (Double(ratingString)! * 100).rounded()/100
                self.providerRatingLabel.text = String(format: "%.2f", roundedRating)
            }
            })
        }
        
        //Hexagon SHape
        let lineWidth = CGFloat(7.0)
        let rect = CGRect(x: 0, y: 0.0, width:47, height: 51)
        let sides = 6
        
        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 5.0, rotationOffset: CGFloat(.pi / 2.0))
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineCap = kCALineCapRound
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.white.cgColor
        
        _ = createImage(layer: borderLayer)
        
        
        
        providerProfileImage.contentMode = .scaleAspectFill
        //        profileImage.layer.cornerRadius = 20
        providerProfileImage.layer.masksToBounds = false
        providerProfileImage.layer.mask = borderLayer
        //        profileImage.layer.addSublayer(borderLayer)
        providerProfileImage.isUserInteractionEnabled = true
        //        profileImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleSelectImageView)))
        
        providerProfileImage.loadProfilePicture()
        // Do any additional setup after loading the view.
        // Do any additional setup after loading the view.
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
    func showPopUp(){
        let alert = UIAlertController(title: "Thanks for signing up!", message: "Please check your email in 4 to 5 days. The results of the background check will allow you to publish your listing!", preferredStyle: .alert)
        self.present(alert, animated: true, completion:{
            alert.view.superview?.isUserInteractionEnabled = true
            alert.view.superview?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.alertControllerBackgroundTapped)))
        })
    }
    
    
    @objc func alertControllerBackgroundTapped()
    {
        self.dismiss(animated: true, completion: nil)
    }
}

//
//  paymentViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/29/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import Stripe
import FirebaseDatabase
import FirebaseAuth

class paymentViewController: UIViewController, STPAddCardViewControllerDelegate{

    
    
    @IBOutlet var myPaymentView: UIView!
    
    @IBAction func ExitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        myPaymentView.addGestureRecognizer(swipeLeft)
        getCards()

        // Do any additional setup after loading the view.
    }
    
    @objc func backSwipe(){
        self.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPayment(_ sender: Any) {
        let addCardViewController = STPAddCardViewController()
        addCardViewController.delegate = self
        
            
        

        let navigationControllee = UINavigationController(rootViewController: addCardViewController)
        self.navigationController?.pushViewController(navigationControllee, animated: true)
        self.present(navigationControllee, animated: true) {
        }
        
        
    }
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        // Dismiss add card view controller
        dismiss(animated: true)
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        print("MY TOKEN", token)
        let stripeSourceID = NSUUID().uuidString
        if let user = Auth.auth().currentUser{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            let userReference = databaseReference.root.child("Users").child((user.uid))
            
            userReference.child("stripe").child("sources").child(stripeSourceID).updateChildValues(["token":String(describing: token)])
            
//            userReference.child("stripe").child("sources").child(stripeSourceID).updateChildValues(["token": token])
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func getCards() {
        
        if let user = Auth.auth().currentUser{
            let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
            databaseReference.root.child("Users").child(user.uid).child("stripe").child("sources").observe(.value, with: { (snapshot) in
                for userChild in snapshot.children{
                    let userSnapshot = userChild as! DataSnapshot
                    let dictionary = userSnapshot.value as? [String: Any]
                    if let brand = dictionary!["brand"]{
                        print("BRAND", brand)
                    }
                    if let last4 = dictionary!["last4"]{
                        print("LAST 4", last4)
                    }
                    
                    
                }
            })
        }
    
    }
    
    
}

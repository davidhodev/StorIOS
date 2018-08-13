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

class paymentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, STPAddCardViewControllerDelegate{
    
    
    @IBOutlet weak var paymentTableView: UITableView!
    @IBOutlet var myPaymentView: UIView!
    
    var myPaymentUsers = [myPaymentUser]()
    var exists: Bool?
    var selectedIndexPath: IndexPath?
    
    var selectorIndex: Int?
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = paymentTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! myPaymentCustomTableViewCell
        let shadowPath2 = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 25)
        cell.layer.masksToBounds = false
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 8)
        cell.layer.shadowOpacity = 0.025
        cell.layer.shadowPath = shadowPath2.cgPath
        cell.layer.cornerRadius = 27
        //need to add cell view
        // cell.cellView.layer.cornerRadius = 27
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //add in empty message hiding
        if myPaymentUsers.count == 0{
            self.paymentTableView.isHidden = true
            exists = false
        }
        else{
            self.paymentTableView.isHidden = false
            exists = true
        }
        return myPaymentUsers.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    @IBAction func ExitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //table view
        paymentTableView.delegate = self
        paymentTableView.dataSource = self
        
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
<<<<<<< HEAD
        
=======
        //reload table view
>>>>>>> a59b8828f029acf15e582cada0a6c931bab5a96a
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

//
//  myListViewController.swift
//  Stor
//
//  Created by Jack Feldman on 5/29/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import CoreLocation

class myListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedIndexPath: IndexPath?
    var myListUsers = [myListUser]()
    var buttonIndexPath: Int?
    var exists: Bool?
    var buttonProviderLocation: CLLocationCoordinate2D?
    
    @IBOutlet var myListView: UIView!
    @IBOutlet weak var listIsEmpty: UILabel!
    
    @IBOutlet weak var swipeToRemove: UIButton!
    @IBOutlet weak var myListTableView: UITableView!
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func swipeToRemoveButton(_ sender: Any) {
        [UIButton .animate(withDuration: 0.3, animations: {
            self.swipeToRemove.alpha = 0
        })]
    }
    
    @objc fileprivate func showSwipeToRemove(){
        UIView.animate(withDuration: 0.3, animations: {
            self.swipeToRemove.alpha = 1
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if exists!{
            showSwipeToRemove()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //adding the swipe feature to my List
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(backSwipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.right
        myListView.addGestureRecognizer(swipeLeft)
        
        myListTableView.delegate = self
        myListTableView.dataSource = self
        swipeToRemove.alpha = 0
        getMyList()
        // Do any additional setup after loading the view.
        self.reloadInputViews()
    }
    //takes you to the corresponding annotation
    
    @objc func backSwipe(){
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.myListTableView.reloadData()
            self.reloadInputViews()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if myListUsers.count == 0{
            self.myListTableView.isHidden = true
            self.listIsEmpty.isHidden = false
            exists = false
        }
        else{
            self.myListTableView.isHidden = false
            self.listIsEmpty.isHidden = true
            exists = true
        }
        return myListUsers.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = myListTableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as! myListCustomCell
        
        let user = myListUsers[indexPath.section]
        cell.addressLabel.attributedText = user.address
        cell.priceLabel.attributedText = user.price
        cell.dimensionsLabel.attributedText = user.dimensionsString
        cell.cubicFeetLabel.attributedText = user.cubicString
        cell.nameLabel.attributedText = user.name
        cell.ratingLabel.attributedText = user.rating
        
        cell.toAnnotationButton.tag = indexPath.section
        cell.toAnnotationButton.addTarget(self, action: #selector(self.btnClick(_:)), for: .touchUpInside)
        
        
        myListTableView.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor.white
        cell.layer.cornerRadius = 30
        
        
        
        DispatchQueue.main.async(execute: { () -> Void in
            
            let lineWidth = CGFloat(7.0)
            let rect = CGRect(x: 0, y: 0.0, width: 50, height: 54)
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
            
            let hexagon = createImage(layer: borderLayer)
            
            cell.providerProfilePicture.contentMode = .scaleAspectFill
            cell.providerProfilePicture.layer.masksToBounds = false
            cell.providerProfilePicture.layer.mask = borderLayer
            cell.providerProfilePicture.image = user.providerProfile
            cell.storagePhoto.contentMode = .scaleAspectFill
            cell.storagePhoto.layer.masksToBounds = true
            cell.storagePhoto.image = user.storagePhoto
            
            //shadows
            let shadowPath2 = UIBezierPath(roundedRect: cell.bounds, cornerRadius: 30)
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor(red:0.27, green:0.29, blue:0.36, alpha:1.0).cgColor
            cell.layer.shadowOffset = CGSize(width: CGFloat(2), height: CGFloat(14.0))
            cell.layer.shadowOpacity = 0.0275
            cell.layer.shadowPath = shadowPath2.cgPath
            cell.cellView.layer.cornerRadius = 27
            
        })
        //changing image based on selection
        if (cell.contentView.bounds.size.height.rounded() == 60){
            cell.moreImage.image = UIImage(named: "Expand Arrow")
        }
        else
        {
            print (cell.contentView.bounds.size.height)
            cell.moreImage.image = UIImage(named: "Up Arrow")
        }
        
    
        
        return cell
    }
    
    @objc func btnClick(_ sender:UIButton) {
        buttonIndexPath = sender.tag
        print(buttonIndexPath)
        print("My custom button action")
        performSegue(withIdentifier: "seeMoreSegue", sender: self)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath{
            selectedIndexPath = nil
        }
        else{
            selectedIndexPath = indexPath
        }
        
        var indexPaths: Array<IndexPath> = []
        if let previous = previousIndexPath{
            indexPaths += [previous]
        }
        if let current = selectedIndexPath{
            indexPaths += [current]
        }
        if indexPaths.count > 0{
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! myListCustomCell).watchFrameChanges()
    }
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! myListCustomCell).ignoreFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == selectedIndexPath)
            {
            return myListCustomCell.expandedHeight
        }
        else {
            return myListCustomCell.defaultHeight
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in myListTableView.visibleCells as! [myListCustomCell] {
            cell.ignoreFrameChanges()
        }
        
    }
    
    //makes animations synchronous
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 30
    }
    
    //hides the footer/creates space between sections
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let removeFromList = removeAction(at: indexPath)
        let config = UISwipeActionsConfiguration(actions: [removeFromList])
        config.performsFirstActionWithFullSwipe = false
        return config
        
//        return UISwipeActionsConfiguration(actions: [removeFromList])
    }
    
    func removeAction(at indexPath: IndexPath) -> UIContextualAction{
        let myStorageID = myListUsers[indexPath.section].storageID
        let action = UIContextualAction(style: .destructive, title: "") { (action, view, completion) in
            if let user = Auth.auth().currentUser{
                let databaseReference = Database.database().reference(fromURL: "https://stor-database.firebaseio.com/")
                let userReference = databaseReference.root.child("Users").child((user.uid))
                userReference.child("myList").child(myStorageID!).removeValue()
            }
            
            self.myListUsers.remove(at: indexPath.section)
            self.myListTableView.reloadData()
            completion(true)
        }

        
//        action.image = UIImage(named: "Delete from MyList Button")
        action.backgroundColor = UIColor(patternImage: UIImage(named: "Delete from MyList Button 2")!)
//        action.backgroundColor = UIColor.clear
//        action.image = UIImage(named: "Delete from MyList Button 2")!
        
        
        return action
    }
    
    
    
    func getMyList(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).child("myList").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
                print("USER SNAPSHOT: ", userSnapshot)
                let dictionary = userSnapshot.value as? [String: String?]
                let user = myListUser()
                user.providerID = dictionary!["myListProvider0"] as? String
                user.storageID = dictionary!["myListStorage0"] as? String
                user.getAddress()
                user.getData()
                self.myListUsers.append(user)
                
                DispatchQueue.main.async {
                    self.myListTableView.reloadData()
                }
                

            
                    
            }
            }, withCancel: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "seeMoreSegue"{
            print("Prepping")
            let destinationController = segue.destination as! AnnotationPopUp
            let user = self.myListUsers[buttonIndexPath!]
            destinationController.providerID = user.providerID
//            destinationController.providerAddress = user.address
            destinationController.storageID = user.storageID
            
            let locationManager = CLLocationManager()
            
            destinationController.userLocation = locationManager.location
            destinationController.providerLocation = user.providerLocation
            
            
        }
            
    }
    
    
}

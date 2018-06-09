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
    var buttonProviderLocation: CLLocationCoordinate2D?
    
    
    @IBOutlet weak var myListTableView: UITableView!
    @IBAction func exitButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        myListTableView.delegate = self
        myListTableView.dataSource = self
        getMyList()
        // Do any additional setup after loading the view.
    }
    //takes you to the corresponding annotation
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
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
            cell.storagePhoto.image = user.storagePhoto
            
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
//        else if (myListCustomCell.opened == true && indexPath == selectedIndexPath) {
//            print(myListCustomCell.opened)
//                myListCustomCell.opened = false
//                return myListCustomCell.defaultHeight
//        }
//
//        else if (myListCustomCell.opened == false){
//            print(myListCustomCell.opened)
//              return myListCustomCell.defaultHeight
//        }
//
//        else if (myListCustomCell.opened == true){
//            print(myListCustomCell.opened)
//             return myListCustomCell.expandedHeight
//        }
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
    
    func getMyList(){
        let uid = Auth.auth().currentUser?.uid
        Database.database().reference().child("Users").child(uid!).child("myList").observeSingleEvent(of: .value, with: { (snapshot) in
            for userChild in snapshot.children{
                let userSnapshot = userChild as! DataSnapshot
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

//
//  myListCustomCell.swift
//  Stor
//
//  Created by David Ho on 6/5/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class myListCustomCell: UITableViewCell {
    
    var isObserving = false;
    
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dimensionsLabel: UILabel!
    @IBOutlet weak var cubicFeetLabel: UILabel!
    @IBOutlet weak var providerProfilePicture: UIImageView!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var toAnnotationButton: UIButton!
    
    @IBOutlet weak var storagePhoto: UIImageView!
    
    
    class var expandedHeight: CGFloat {get { return 343 }}
    class var defaultHeight: CGFloat {get { return 60 }}

    

//     func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//     if segue.identifier == "toAnnotationSegue"{
//         let destinationController = segue.destination as! AnnotationPopUp
//        print("YPOPOPOPOP")
////         destinationController.providerID = self.annotationUID
////         destinationController.providerAddress = self.annotationAddress
////         destinationController.storageID = self.annotationStorageID
////         destinationController.providerLocation = self.annotationLocation
////         destinationController.userLocation = self.storMapKit.userLocation.location
//         }
//     }
    
    func checkHeight(){
        cellView.isHidden = (frame.size.height < myListCustomCell.expandedHeight)
    }
    
    func watchFrameChanges(){
        if !isObserving{
            addObserver(self, forKeyPath: "frame", options: .new, context: nil)
            isObserving = true
        }
    }
    
    func ignoreFrameChanges(){
        if isObserving{
            removeObserver(self, forKeyPath: "frame")
            isObserving = false
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame"{
            checkHeight()
        }
    }
    

    
}

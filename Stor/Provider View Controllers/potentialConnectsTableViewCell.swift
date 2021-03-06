//
//  potentialConnectsTableViewCell.swift
//  Stor
//
//  Created by David Ho on 6/14/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class potentialConnectsTableViewCell: UITableViewCell {

     var isObserving = false;
    
    static var opened = false
    
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var dropDownImage: UIImageView!
    @IBOutlet weak var dropOffTime: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var acceptButton: UIButton!
    @IBOutlet weak var declineButton: UIButton!
    
    @IBOutlet weak var confirmDropoffLabel: UILabel!
    @IBOutlet weak var confirmPickupLabel: UILabel!
    @IBOutlet weak var confirmDropoffButton: UIButton!
    @IBOutlet weak var confirmPickupButton: UIButton!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var rejectLabel: UILabel!
    
    class var expandedHeight: CGFloat {get { return 256 }}
    class var defaultHeight: CGFloat {get { return 60 }}
    
   
    func checkHeight(){
        cellView.isHidden = (frame.size.height < potentialConnectsTableViewCell.expandedHeight)
        print((frame.size.height <= potentialConnectsTableViewCell.expandedHeight))
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

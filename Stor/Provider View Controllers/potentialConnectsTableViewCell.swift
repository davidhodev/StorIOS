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
    
    
    
    
    class var expandedHeight: CGFloat {get { return 259 }}
    class var defaultHeight: CGFloat {get { return 63 }}
    
   
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

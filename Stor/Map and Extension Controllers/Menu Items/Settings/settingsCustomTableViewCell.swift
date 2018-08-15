//
//  settingsCustomCellTableViewCell.swift
//
//
//  Created by David Ho on 6/4/18.
//

import UIKit

class settingsCustomCellTableViewCell: UITableViewCell {
    
    var isObserving = false;
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var dropDownOne: UILabel! // Label
    //switch variables
    @IBOutlet weak var pushNotificationsControl: UISwitch!
    @IBOutlet weak var storContactControl: UISwitch!
    var shadowLayer: CAShapeLayer!
    
    class var expandedHeight: CGFloat {get { return 150 }}
    class var defaultHeight: CGFloat {get { return 60 }}
    
    func checkHeight(){
        if (frame.size.height < settingsCustomCellTableViewCell.expandedHeight){
            cellView.isHidden = true
        }
        else{
            cellView.isHidden = false
        }
//        cellView.isHidden = (frame.size.height < settingsCustomCellTableViewCell.expandedHeight)
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
    
    @IBAction func pushNotificationsPressed(_ sender: UISwitch) {
        if pushNotificationsControl.isOn{
            globalVariablesViewController.isPushNotificationsOn = 1
        }
        else{
            globalVariablesViewController.isPushNotificationsOn = 0
        }
    }
    
    @IBAction func storContactPressed(_ sender: UISwitch) {
        if storContactControl.isOn{
            globalVariablesViewController.isStorContactOn = 1
        }
        else{
            globalVariablesViewController.isStorContactOn = 0
        }
    }
    
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame"{
            checkHeight()
        }
    }
    
    
}


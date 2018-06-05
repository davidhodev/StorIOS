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
    @IBOutlet weak var dropDownTwo: UILabel!
    

    class var expandedHeight: CGFloat {get { return 200 }}
    class var defaultHeight: CGFloat {get { return 60 }}
    
    
    
    func checkHeight(){
        cellView.isHidden = (frame.size.height < settingsCustomCellTableViewCell.expandedHeight)
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


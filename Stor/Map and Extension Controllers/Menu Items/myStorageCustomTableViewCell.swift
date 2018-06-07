//
//  myStorageCustomTableViewCell.swift
//  Stor
//
//  Created by David Ho on 6/6/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class myStorageCustomTableViewCell: UITableViewCell {

        var isObserving = false;
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var addressLabel: UILabel!
    
    
    class var expandedHeight: CGFloat {get { return 343 }}
    class var defaultHeight: CGFloat {get { return 60 }}
    
    
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

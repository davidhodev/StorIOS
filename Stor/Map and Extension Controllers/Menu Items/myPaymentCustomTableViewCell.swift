//
//  myPaymentCustomTableViewCell.swift
//  Stor
//
//  Created by Cole Feldman on 8/13/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class myPaymentCustomTableViewCell: UITableViewCell {
    
    var isObserving = false;
 

    @IBOutlet weak var setAsPrimaryButton: UIButton!
    @IBOutlet weak var deleteCardOutlet: UIButton!
    @IBOutlet weak var last4label: UILabel!

    @IBOutlet weak var cellView: myPaymentCustomTableViewCell!
    static var opened = false
    
    class var expandedHeight: CGFloat {get { return 190 }}
    class var defaultHeight: CGFloat {get { return 60 }}
    
    
    
    func checkHeight(){
        print(frame.size.height)
        cellView.isHidden = (frame.size.height < myPaymentCustomTableViewCell.expandedHeight)
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

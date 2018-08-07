//
//  CustomLoader.swift
//  Stor
//
//  Created by Cole Feldman on 8/7/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit

class CustomLoader: UIView {
    
    static let instance = CustomLoader()
    
    //defining properties of background view
    //chose color that we want
    var viewColor = UIColor(red: <#T##CGFloat#>, green: <#T##CGFloat#>, blue: <#T##CGFloat#>, alpha: <#T##CGFloat#>)
    var setAlpha: CGFloat = 0.5
    var gifName: String = ""

    lazy var transparentView: UIView = {
        let transparentView = UIView(frame: UIScreen.main.bounds)
        //creates background, grey
        transparentView.backgroundColor = viewColor.withAlphaComponent(setAlpha)
        transparentView.isUserInteractionEnabled = false
        return transparentView
    }()
    
    lazy var gifImage: UIImageView = {
        let gifImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        gifImage.contentMode = .scaleAspectFit
        gifImage.center = transparentView.center
        gifImage.isUserInteractionEnabled = false
        //loading gif, maybe method comes in later
        gifImage.loadGif(name: gifName)
        return gifImage
    }()
    
    func showLoader(){
        self.addSubview(transparentView)
        self.transparentView.addSubview(gifImage)
        self.transparentView.bringSubview(toFront: self.gifImage)
        UIApplication.shared.keyWindow?.addSubview(transparentView)
    }
    
    func hideLoader(){
        self.transparentView.removeFromSuperview()
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

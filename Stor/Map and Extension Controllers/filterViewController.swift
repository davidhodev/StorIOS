//
//  filterViewController.swift
//  Stor
//
//  Created by Jack Feldman on 6/6/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import SwiftRangeSlider

class filterViewController: UIViewController {

    
    @IBOutlet weak var priceSliderOutlet: UISlider!
    @IBOutlet weak var coverSliderOutlet: UISlider!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var smallButtonImage: UIButton!
    @IBOutlet weak var mediumButtonImage: UIButton!
    @IBOutlet weak var largeButtonImage: UIButton!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    @IBOutlet weak var thumbCap56: UIImageView!
    @IBOutlet weak var thumbCap86: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalVariablesViewController.buttonOn = 0
        coverSliderOutlet.isHidden = true
        thumbCap56.isHidden = true
        thumbCap86.isHidden = true
    }
    
    @IBAction func smallSizeButtonPressed(_ sender: UIButton) {
        // turn button on
        if (globalVariablesViewController.buttonOn! % 10 == 0){
            thumbCap56.isHidden = true
            thumbCap86.isHidden = true
        globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 1
            smallButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
            smallLabel.font = UIFont(name: "Dosis-Bold", size: 15.0)
            smallLabel.textColor = UIColor.black
            if(priceSliderOutlet.value > 0)
            {
                if (priceSliderOutlet.value == 250){
                    priceLabel.text = "$0 – $250+"
                    coverSliderOutlet.isHidden = true
                }
                else{
                    var priceString = "$0 – $"
                    let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                    priceString += currentPrice
                    priceLabel.text = priceString
                    coverSliderOutlet.isHidden = true
                }
            }
            else {
                priceLabel.text = "$0"
                coverSliderOutlet.isHidden = true
            }
        }
        // turn button off
        else {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 1
            smallButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
            smallLabel.font = UIFont(name: "Dosis-Light", size: 16.0)
            smallLabel.textColor = UIColor(red:0.16, green:0.15, blue:0.35, alpha:1.0)
            // if medium on
            if (globalVariablesViewController.buttonOn! % 100 >= 10){
                //if value under 70
                if (priceSliderOutlet.value <= 70){
                    priceLabel.text = "$70"
                    priceSliderOutlet.value = 70
                    coverSliderOutlet.value = 56
                    coverSliderOutlet.isHidden = false
                    thumbCap56.isHidden = false
                }
                else
                {
                    if (priceSliderOutlet.value == 250){
                        priceLabel.text = "$70 – $250+"
                        coverSliderOutlet.value = 56
                        coverSliderOutlet.isHidden = false
                        thumbCap56.isHidden = false
                    }
                    else{
                        var priceString = "$70 – $"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceLabel.text = priceString
                        coverSliderOutlet.value = 56
                        coverSliderOutlet.isHidden = false
                        thumbCap56.isHidden = false
                    }
                }
            }
            // if large on and medium off
            else{
                if (globalVariablesViewController.buttonOn! >= 100){
                    thumbCap86.isHidden = false
                    if (priceSliderOutlet.value <= 100){
                        priceSliderOutlet.value = 100
                        priceLabel.text = "$100"
                        coverSliderOutlet.value = 86
                        coverSliderOutlet.isHidden = false
                    }
                    else{
                        if (priceSliderOutlet.value == 250){
                            priceLabel.text = "$100 – $250+"
                            coverSliderOutlet.value = 86
                            coverSliderOutlet.isHidden = false
                        }
                        else{
                            var priceString = "$100 – $"
                            let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                            priceString += currentPrice
                            priceLabel.text = priceString
                            coverSliderOutlet.value = 86
                            coverSliderOutlet.isHidden = false
                        }
                    }
                }
            }
        }
    }
    @IBAction func mediumSizeButtonPressed(_ sender: UIButton) {
        // turn button on
        if (globalVariablesViewController.buttonOn! % 100 < 10) {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 10
            mediumButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
            mediumLabel.font = UIFont(name: "Dosis-Bold", size: 15.0)
            mediumLabel.textColor = UIColor.black
            // if small is off
            if(globalVariablesViewController.buttonOn! % 10 == 0){
                thumbCap56.isHidden = false
                thumbCap86.isHidden = true
                coverSliderOutlet.value = 56
                coverSliderOutlet.isHidden = false
                if (priceSliderOutlet.value <= 70){
                    priceLabel.text = "$70"
                    priceSliderOutlet.value = 70
                }
                else if (priceSliderOutlet.value > 70){
                    if (priceSliderOutlet.value == 250){
                        priceLabel.text = "$70 – $250+"
                    }
                    else{
                        var priceString = "$70 – $"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceLabel.text = priceString
                    }
                }
            }
        }
        //turn button off
        else{
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 10
            mediumButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
            mediumLabel.font = UIFont(name: "Dosis-Light", size: 16.0)
            mediumLabel.textColor = UIColor(red:0.16, green:0.15, blue:0.35, alpha:1.0)
            // if small off
            if (globalVariablesViewController.buttonOn! % 10 == 0){
                //if large on
                if (globalVariablesViewController.buttonOn! >= 100){
                    coverSliderOutlet.value = 86
                    coverSliderOutlet.isHidden = false
                    thumbCap86.isHidden = false
                    thumbCap56.isHidden = true
                    //if value is less or equal to 100
                    if (priceSliderOutlet.value <= 100){
                        priceLabel.text = "$100"
                        priceSliderOutlet.value = 100
                    }
                    // value greater than 100
                    else if(priceSliderOutlet.value > 100){
                        //value = 250
                        if(priceSliderOutlet.value == 250){
                            var priceString = "$100 – $"
                            let endString = "+"
                            let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                            priceString += currentPrice
                            priceString += endString
                            priceLabel.text = priceString
                        }
                        // value between 250 and 100
                        else{
                            var priceString = "$100 – $"
                            let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                            priceString += currentPrice
                            priceLabel.text = priceString
                        }
                    }
                }
                else{
                    coverSliderOutlet.isHidden = true
                    thumbCap86.isHidden = true
                    thumbCap56.isHidden = true
                    if (priceSliderOutlet.value < 250){
                        var priceString = "$0 – $"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceLabel.text = priceString
                    }
                    else{
                        var priceString = "$0 – $"
                        let endString = "+"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceString += endString
                        priceLabel.text = priceString
                    }
                }
            }
        }
    }
    
    @IBAction func largeSizeButtonPressed(_ sender: UIButton) {
        // button on
        if (globalVariablesViewController.buttonOn! < 100){
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 100
            //change image to on, change label to bold
            largeButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
            largeLabel.font = UIFont(name: "Dosis-Bold", size: 15.0)
            largeLabel.textColor = UIColor.black
            if (globalVariablesViewController.buttonOn! % 10 == 0 && globalVariablesViewController.buttonOn! % 100 <= 9){
                coverSliderOutlet.value = 86
                coverSliderOutlet.isHidden = false
                thumbCap86.isHidden = false
                if (priceSliderOutlet.value <= 100){
                    priceLabel.text = "$100"
                    priceSliderOutlet.value = 100
                }
                if (priceSliderOutlet.value > 100){
                    if (priceSliderOutlet.value == 250){
                        var priceString = "$100 – $"
                        let endString = "+"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceString += endString
                        priceLabel.text = priceString
                    }
                    else{
                        var priceString = "$100 – $"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceLabel.text = priceString
                    }
                }
            }
        }
        // button off
        else{
            globalVariablesViewController.buttonOn! =  globalVariablesViewController.buttonOn! - 100
            //change image to off, label to unbold
             largeButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
            largeLabel.font = UIFont(name: "Dosis-Light", size: 16.0)
            largeLabel.textColor = UIColor(red:0.16, green:0.15, blue:0.35, alpha:1.0)
            // small off
            if (globalVariablesViewController.buttonOn! % 10 == 0){
                // medium off
                if (globalVariablesViewController.buttonOn! % 100 < 10){
                    coverSliderOutlet.isHidden = true
                    thumbCap86.isHidden = true
                    thumbCap56.isHidden = true
                    if (priceSliderOutlet.value == 250){
                        var priceString = "$0 – $"
                        let endString = "+"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceString += endString
                        priceLabel.text = priceString
                    }
                    else{
                        var priceString = "$0 – $"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceLabel.text = priceString
                    }
                }
                // medium on
                else{
                    coverSliderOutlet.value = 56
                    coverSliderOutlet.isHidden = false
                    thumbCap56.isHidden = false
                    if (priceSliderOutlet.value != 250){
                        var priceString = "$70 – $"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceLabel.text = priceString
                    }
                    else{
                        var priceString = "$70 – $"
                        let endString = "+"
                        let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                        priceString += currentPrice
                        priceString += endString
                        priceLabel.text = priceString
                    }
                }
            }
            else if (priceSliderOutlet.value == 250){
                thumbCap86.isHidden = true
                thumbCap56.isHidden = true
                var priceString = "$0 – $"
                let endString = "+"
                let currentPrice = String(describing: Int(priceSliderOutlet.value.rounded()))
                priceString += currentPrice
                priceString += endString
                priceLabel.text = priceString
                coverSliderOutlet.isHidden = true
            }
        }
    }
    
    @IBAction func priceSlider(_ sender: UISlider) {
        priceSliderOutlet.isContinuous = true
        if (globalVariablesViewController.buttonOn! % 10 != 0 || globalVariablesViewController.buttonOn! == 0){
            var priceText = ""
            var priceTextEnd = ""
            if priceSliderOutlet.value == Float(250){
                priceText = "$0 – $"
                priceTextEnd = "+"
            }
            else if priceSliderOutlet.value == priceSliderOutlet.minimumValue{
                priceText = "$"
                priceTextEnd = ""
            }
            else{
                priceText = "$0 – $"
                priceTextEnd = ""
            }
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
            priceText += String(describing: Int(sender.value.rounded()))
            priceText += priceTextEnd
            priceLabel.text = priceText
            priceSliderOutlet.value = sender.value
        }
        else if (globalVariablesViewController.buttonOn! % 100 >= 10){
            var priceText = ""
            var priceTextEnd = ""
            if (globalVariablesViewController.buttonOn! > 100 && priceSliderOutlet.value < 100){
                priceSliderOutlet.value = 70
            }
            else if (globalVariablesViewController.buttonOn! < 100 && priceSliderOutlet.value < 70){
                priceSliderOutlet.value = 70
            }
            if priceSliderOutlet.value == Float(250){
                priceText = "$70 – $"
                priceTextEnd = "+"
            }
            else if priceSliderOutlet.value == Float(70){
                priceText = "$"
                priceTextEnd = ""
            }
            else{
                priceText = "$70 – $"
                priceTextEnd = ""
            }
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
            priceText += String(describing: Int(sender.value.rounded()))
            priceText += priceTextEnd
            priceLabel.text = priceText
            priceSliderOutlet.value = sender.value
        }
        else{
            var priceText = ""
            var priceTextEnd = ""
            if (priceSliderOutlet.value < 100){
                sender.value = 100
                priceSliderOutlet.value = 100
            }
            if priceSliderOutlet.value == Float(250){
                priceText = "$100 – $"
                priceTextEnd = "+"
            }
            else if priceSliderOutlet.value == Float(100){
                priceText = "$"
                priceTextEnd = ""
            }
            else{
                priceText = "$100 – $"
                priceTextEnd = ""
            }
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
            priceText += String(describing: Int(sender.value.rounded()))
            priceText += priceTextEnd
            priceLabel.text = priceText
            priceSliderOutlet.value = sender.value
        }
    }
    
    @IBAction func dismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func bigDismissButton(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func applyFilterPressed(_ sender: Any) {
        
        if priceSliderOutlet.value == 250{
            globalVariablesViewController.priceFilter = Int(10000000)
            filterManager.shared.mapVC.filterAnnotations()
        }
        else{
            globalVariablesViewController.priceFilter = Int(priceSliderOutlet.value)
            filterManager.shared.mapVC.filterAnnotations()
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

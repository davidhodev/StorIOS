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
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var smallButtonImage: UIButton!
    @IBOutlet weak var mediumButtonImage: UIButton!
    @IBOutlet weak var largeButtonImage: UIButton!
    @IBOutlet weak var smallLabel: UILabel!
    @IBOutlet weak var largeLabel: UILabel!
    @IBOutlet weak var mediumLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalVariablesViewController.buttonOn = 0
    }
    
    @IBAction func smallSizeButtonPressed(_ sender: UIButton) {
        if (globalVariablesViewController.buttonOn! % 10 == 0){
        globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 1
            smallButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
            smallLabel.font = UIFont(name: "Dosis-Bold", size: 15.0)
            smallLabel.textColor = UIColor.black
        }
        else {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 1
            smallButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
            smallLabel.font = UIFont(name: "Dosis-Regular", size: 16.0)
            smallLabel.textColor = UIColor(red:0.16, green:0.15, blue:0.35, alpha:1.0)
        }
//        if (globalVariablesViewController.buttonOn! >= 100 && globalVariablesViewController.buttonOn! % 100 < 10)
//        {
//            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 100
//        // change small image to selected and big image to unselected
//            smallButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
//            largeButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
//        }
    }
    
    @IBAction func mediumSizeButtonPressed(_ sender: UIButton) {
        if (globalVariablesViewController.buttonOn! % 100 < 10) {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 10
            mediumButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
            mediumLabel.font = UIFont(name: "Dosis-Bold", size: 15.0)
            mediumLabel.textColor = UIColor.black
        }
        else{
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 10
            mediumButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
            mediumLabel.font = UIFont(name: "Dosis-Regular", size: 16.0)
            mediumLabel.textColor = UIColor(red:0.16, green:0.15, blue:0.35, alpha:1.0)
        }
        
    }
    @IBAction func largeSizeButtonPressed(_ sender: UIButton) {
        if (globalVariablesViewController.buttonOn! < 100){
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 100
            //change image to on, change label to bold
            largeButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
            largeLabel.font = UIFont(name: "Dosis-Bold", size: 15.0)
            largeLabel.textColor = UIColor.black
        }
        else{
            globalVariablesViewController.buttonOn! =  globalVariablesViewController.buttonOn! - 100
            //change image to off, label to unbold
             largeButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
            largeLabel.font = UIFont(name: "Dosis-Regular", size: 16.0)
            largeLabel.textColor = UIColor(red:0.16, green:0.15, blue:0.35, alpha:1.0)
        }
//        if (globalVariablesViewController.buttonOn! % 10 == 1 && globalVariablesViewController.buttonOn! % 100 < 10){
//            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 1
//            //change large image to on, large label to bold, small image to grey, small label to unbold
//            largeButtonImage.setImage(UIImage(named: "Blue Check"), for: .normal)
//            smallButtonImage.setImage(UIImage(named: "Grey Circle"), for: .normal)
//        }
    }
    
    @IBAction func priceSlider(_ sender: UISlider) {
        priceSliderOutlet.isContinuous = true
        if (globalVariablesViewController.buttonOn! % 10 != 0 || globalVariablesViewController.buttonOn! == 0){
            var priceText = ""
        
            if priceSliderOutlet.value == Float(250){
                priceText = "> $"
            }
            else if priceSliderOutlet.value == priceSliderOutlet.minimumValue{
                priceText = "   $"
            }
            else{
                priceText = "< $"
            }
            let price0 = "0"
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
            priceText += String(describing: sender.value.rounded())
            priceText += price0
            priceLabel.text = priceText
            priceSliderOutlet.value = sender.value
        }
        else if (globalVariablesViewController.buttonOn! % 100 >= 10){
            var priceText = ""
            if (priceSliderOutlet.value < 70){
                priceSliderOutlet.value = 70
            }
            if priceSliderOutlet.value == Float(250){
                priceText = "> $"
            }
            else if priceSliderOutlet.value == Float(70){
                priceText = "   $"
            }
            else{
                priceText = "< $"
            }
            let price0 = "0"
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
            priceText += String(describing: sender.value.rounded())
            priceText += price0
            priceLabel.text = priceText
            priceSliderOutlet.value = sender.value
        }
        else{
            var priceText = ""
            if (priceSliderOutlet.value < 100){
                sender.value = 100
                priceSliderOutlet.value = 100
            }
            if priceSliderOutlet.value == Float(250){
                priceText = "> $"
            }
            else if priceSliderOutlet.value == Float(100){
                priceText = "   $"
            }
            else{
                priceText = "< $"
            }
            let price0 = "0"
            let step: Float = 5
            let roundedValue = round(sender.value / step) * step
            sender.value = roundedValue
            priceText += String(describing: sender.value.rounded())
            priceText += price0
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

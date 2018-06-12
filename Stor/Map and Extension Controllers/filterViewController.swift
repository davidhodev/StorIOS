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
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        globalVariablesViewController.buttonOn = 0
        var priceLabelText = ""
        if globalVariablesViewController.priceFilter == nil{
            globalVariablesViewController.priceFilter = 250
        }
        if globalVariablesViewController.priceFilter == 250{
            priceSliderOutlet.setValue(globalVariablesViewController.priceFilter!, animated: true)
            priceLabelText = "> $"
            priceLabelText += (String(describing: globalVariablesViewController.priceFilter!))
            priceLabelText += "0"
            priceLabel.text = priceLabelText
        }
        if globalVariablesViewController.priceFilter == 0{
            priceSliderOutlet.setValue(globalVariablesViewController.priceFilter!, animated: true)
            priceLabelText = "   $"
            priceLabelText += String(describing: globalVariablesViewController.priceFilter!)
            priceLabelText += "0"
            priceLabel.text = priceLabelText
        }
        else{
            priceSliderOutlet.setValue(globalVariablesViewController.priceFilter!, animated: true)
            priceLabelText = "< $"
            priceLabelText += String(describing: globalVariablesViewController.priceFilter!)
            priceLabelText += "0"
            priceLabel.text = priceLabelText
        }
    }
    
    @IBAction func smallSizeButtonPressed(_ sender: UIButton) {
        if (globalVariablesViewController.buttonOn! % 10 == 0){
        globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 1
        //change button image to selected
        }
        else {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 1
        //change back button image to unselected
        }
        if (globalVariablesViewController.buttonOn! >= 100 && globalVariablesViewController.buttonOn! % 100 < 10)
        {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 100
        // change small image to selected and big image to unselected
        }
    }
    
    @IBAction func mediumSizeButtonPressed(_ sender: UIButton) {
        if (globalVariablesViewController.buttonOn! % 100 < 10) {
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 10
            //change image to selected
        }
        else{
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 10
            //change image to unselected
        }
        
    }
    @IBAction func largeSizeButtonPressed(_ sender: UIButton) {
        if (globalVariablesViewController.buttonOn! < 100){
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! + 100
            //change image to on
        }
        else{
            globalVariablesViewController.buttonOn! =  globalVariablesViewController.buttonOn! - 100
            //change image to off
        }
        if (globalVariablesViewController.buttonOn! % 10 == 1 && globalVariablesViewController.buttonOn! % 100 < 10){
            globalVariablesViewController.buttonOn! = globalVariablesViewController.buttonOn! - 1
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
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
            globalVariablesViewController.priceFilter = priceSliderOutlet.value
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
            globalVariablesViewController.priceFilter = priceSliderOutlet.value
        }
        else{
            var priceText = ""
            if (priceSliderOutlet.value < 100){
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
            globalVariablesViewController.priceFilter = priceSliderOutlet.value
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

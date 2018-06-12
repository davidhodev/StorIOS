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
        
    }
    
    @IBAction func smallSizeButtonPressed(_ sender: UIButton) {
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        else if globalVariablesViewController.priceFilter == 0{
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
    
    @IBAction func priceSlider(_ sender: UISlider) {
        priceSliderOutlet.isContinuous = true
        
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

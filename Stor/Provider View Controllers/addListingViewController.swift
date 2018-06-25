//
//  addListingViewController.swift
//  Stor
//
//  Created by David Ho on 6/18/18.
//  Copyright © 2018 David Ho. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase


extension String{
    var digits: String{
        return components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
}

class Dates{
    var day = [String]()
    var hour = [String]()
    init(day: [String], hour: [String]){
        self.day = day
        self.hour = hour
    }
}

class addListingViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
  // keeping track of the rows
    var outputTime: String?
    var previousRow: Int?
    var selectedRow0: Int?
    var selectedRow: Int?
    var days = [Dates]()

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    // dimensions variables, slider and their labels w values
    @IBOutlet var dimensionsView: UIView!
    @IBOutlet weak var widthLabel: UILabel!
    @IBOutlet weak var widthSliderOutlet: UISlider!
    @IBOutlet weak var lengthSliderOutlet: UISlider!
    @IBOutlet weak var lengthLabel: UILabel!
    @IBOutlet weak var heightSliderOutlet: UISlider!
    @IBOutlet weak var heightLabel: UILabel!
    //widthxlengthxheight
    @IBOutlet weak var cubicFeetLabel: UILabel!
    //ft3 with superscript
    @IBOutlet weak var feetCubedLabel: UILabel!
    @IBOutlet weak var savedDimensionsLabel: UILabel!
    @IBOutlet weak var savedCubicFeetLabel: UILabel!
    @IBOutlet weak var dimensionsErrorLabel: UILabel!
    @IBOutlet weak var placeHolderDimensionsLabel: UILabel!
    
    //description variables
    @IBOutlet var descriptionView: UIView!
    @IBOutlet weak var userDescriptionText: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    let picker = UIPickerView()
    // 3 text views to take in the text from picker view
    @IBOutlet weak var timePicker: UITextView!
    @IBOutlet weak var timePicker2: UITextView!
    @IBOutlet weak var timePicker3: UITextView!
    @IBOutlet weak var errorLabel: UITextView!
    @IBOutlet weak var errorLabel2: UITextView!
    
    //availability variables
    @IBOutlet var availabilityView: UIView!
    @IBOutlet weak var availabilityOne: UILabel!
    @IBOutlet weak var availabilityTwo: UILabel!
    @IBOutlet weak var availabilityThree: UILabel!
    @IBOutlet weak var availabilityInfoLabel: UILabel!
    
    //blur effect and window
    @IBOutlet weak var blurView: UIVisualEffectView!
    var blurEffect: UIVisualEffect!
    
    //create first picker view, instantiates toolbars for each of the three selectors
    func createFirstPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector((donePressed)))
        toolbar.setItems([done], animated: false)
        timePicker.inputAccessoryView = toolbar
        timePicker.inputView = picker
    }
    
    func createSecondPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector((donePressed2)))
        toolbar.setItems([done], animated: false)
        timePicker2.inputAccessoryView = toolbar
        timePicker2.inputView = picker
    }
    
    func createThirdPickerView(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector((donePressed3)))
        toolbar.setItems([done], animated: false)
        timePicker3.inputAccessoryView = toolbar
        timePicker3.inputView = picker
    }
    
    // number of columns in picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    // number of items per column
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //first column
        if (component == 0){
            return 8
        }
            //second column
        else{
            return days[0].hour.count
        }
    }
    
    //changing font inside picker view
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: UILabel
        if let view = view as? UILabel {
            label = view
        } else {
            label = UILabel()
            label.font = UIFont(name:"Dosis-Regular", size:18)
            label.textAlignment = .center
        }
        if component == 0{
            label.text = days[0].day[row]
        }
        else if component == 1{
            label.text = days[0].hour[row]
        }
        return label
    }
    // did select in picker view, creates static label
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if (component == 0){
            if (row != 0){
                selectedRow0 = row
            }
            else{
                selectedRow0 = 0
            }
        }
        if (component == 1){
            if (row != 0)
            {
                if (row < 8){
                    days[0].hour[row] += " a.m."
                    if previousRow != nil{
                        print("PREVIOUS ROW REMOVE", days[0].hour[previousRow!])
                        days[0].hour[previousRow!].removeLast(5)
                    }
                    previousRow = row
                    selectedRow = row
                    pickerView.reloadComponent(1)
                }
                else{
                    days[0].hour[row] += " p.m."
                    if previousRow != nil{
                        days[0].hour[previousRow!].removeLast(5)
                    }
                    previousRow = row
                    selectedRow = row
                    pickerView.reloadComponent(1)
                }
            }
            else{
                selectedRow = 0
            }
        }
    }

    // fills in time slot for first picker label, adds in a.m.'s and p.m.'s
    @objc func donePressed(){
        if checkValidTimes(){
            var timePickerString = days[0].day[selectedRow0!]
            timePickerString += ", "
            timePickerString += days[0].hour[selectedRow!]
            timePickerString += " – "
            
            // add in window of time
//            timePickerString += days[0].secondHour[selectedRow2!]
            var endTimeString = ""
            if selectedRow! == 19{
                endTimeString = "12 a.m."
            }
            else if selectedRow! == 7{
                endTimeString = "12 p.m."
            }
            else{
                let endTimeFirstRow = selectedRow! + 1
                endTimeString = days[0].hour[endTimeFirstRow]
                if selectedRow! < 7{
                    endTimeString += " a.m."
                }
                else{
                    endTimeString += " p.m"
                }
            }
            timePickerString += endTimeString
            
            timePicker.text = "\(timePickerString)"
            
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.selectRow(0, inComponent: 1, animated: false)
            days = [Dates(day: ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], hour: ["", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"])]
            previousRow = nil
            errorLabel.isHidden = true
            self.view.endEditing(true)
        }
        else{
            errorLabel.isHidden = false
        }
    }
    //second time slot for picker
    @objc func donePressed2(){
        if checkValidTimes(){
            var timePickerString = days[0].day[selectedRow0!]
            timePickerString += ", "
            timePickerString += days[0].hour[selectedRow!]
            timePickerString += " – "
            
            // add in window of time
            //            timePickerString += days[0].secondHour[selectedRow2!]
            var endTimeString = ""
            if selectedRow! == 19{
                endTimeString = "12 a.m."
            }
            else if selectedRow! == 7{
                endTimeString = "12 p.m."
            }
            else{
                let endTimeFirstRow = selectedRow! + 1
                endTimeString = days[0].hour[endTimeFirstRow]
                if selectedRow! < 7{
                    endTimeString += " a.m."
                }
                else{
                    endTimeString += " p.m"
                }
            }
            timePickerString += endTimeString
            
            timePicker2.text = "\(timePickerString)"
            
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.selectRow(0, inComponent: 1, animated: false)
            days = [Dates(day: ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], hour: ["", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"])]
            previousRow = nil
            errorLabel.isHidden = true
            self.view.endEditing(true)
        }
        else{
            errorLabel.isHidden = false
        }
    }
    // third time slot for picker
    @objc func donePressed3(){
        if checkValidTimes(){
            var timePickerString = days[0].day[selectedRow0!]
            timePickerString += ", "
            timePickerString += days[0].hour[selectedRow!]
            timePickerString += " – "
            
            // add in window of time
            //            timePickerString += days[0].secondHour[selectedRow2!]
            var endTimeString = ""
            if selectedRow! == 19{
                endTimeString = "12 a.m."
            }
            else if selectedRow! == 7{
                endTimeString = "12 p.m."
            }
            else{
                let endTimeFirstRow = selectedRow! + 1
                endTimeString = days[0].hour[endTimeFirstRow]
                if selectedRow! < 7{
                    endTimeString += " a.m."
                }
                else{
                    endTimeString += " p.m"
                }
            }
            timePickerString += endTimeString
            
            timePicker3.text = "\(timePickerString)"
            
            picker.selectRow(0, inComponent: 0, animated: false)
            picker.selectRow(0, inComponent: 1, animated: false)
            days = [Dates(day: ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], hour: ["", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"])]
            previousRow = nil
            errorLabel.isHidden = true
            self.view.endEditing(true)
        }
        else{
            errorLabel.isHidden = false
        }
    }
    // final add listing button, need to add checks for all filled out/parking spot
    @IBAction func addListingButton(_ sender: Any) {
        print("add Listing!")
    }
    //exit button for full page
    @IBAction func exitButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    //takes you to dimensions pop up
    @IBAction func addDimensionsPressed(_ sender: UIButton) {
        animateInDimensions()
    }
    //save button for dimensions
    @IBAction func exitDimensions(_ sender: UIButton) {
        if (widthFeet != 0 && lengthFeet != 0 && heightFeet != 0){
            animateOutDimensions()
            var cubicFinalString = cubicFeetLabel.text
            cubicFinalString?.append(" ")
            cubicFinalString?.append(feetCubedLabel.text!)
            savedCubicFeetLabel.text = cubicFinalString
            savedCubicFeetLabel.isHidden = false
            var dimensionsFinalString = String(describing: widthFeet!)
            dimensionsFinalString += (" X ")
            dimensionsFinalString += String(describing: lengthFeet!)
            savedDimensionsLabel.text = dimensionsFinalString
            savedDimensionsLabel.isHidden = false
            placeHolderDimensionsLabel.isHidden = true
        }
        else{
            dimensionsErrorLabel.isHidden = false
        }
    }
    
    //takes you to description pop up
    @IBAction func addDescriptionPressed(_ sender: UIButton) {
        animateInDescriptions()
    }
    // save button for descriptions
    @IBAction func exitDescription(_ sender: UIButton) {
        descriptionLabel.text = userDescriptionText.text
        animateOutDescriptions()
    }
    
    //takes you to availability pop up
    @IBAction func addAvailabilityPressed(_ sender: UIButton) {
        animateInAvailability()
    }
    //save button for availability
    @IBAction func exitAvailability(_ sender: UIButton) {
        if (timePicker.text.contains("Choose") || timePicker2.text.contains("Choose") || timePicker3.text.contains("Choose")){
            errorLabel2.isHidden = false
        }
        else if (timePicker.text == timePicker2.text || timePicker.text == timePicker3.text || timePicker2.text == timePicker3.text){
            errorLabel2.isHidden = false
        }
        else{
            errorLabel2.isHidden = true
            availabilityInfoLabel.isHidden = true
            animateOutAvailability()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //feet cubed label hidden
        feetCubedLabel.isHidden = true
        savedCubicFeetLabel.isHidden = true
        savedDimensionsLabel.isHidden = true
        dimensionsErrorLabel.isHidden = true
        let font:UIFont? = UIFont(name: "Dosis-Regular", size:16)
        let fontSuper:UIFont? = UIFont(name: "Dosis-Regular", size:14)
        
        let cubicFeetAttString:NSMutableAttributedString = NSMutableAttributedString(string: "ft3", attributes: [.font:font!])
        cubicFeetAttString.setAttributes([.font:fontSuper!,.baselineOffset:7], range: NSRange(location:2 ,length:1))
        self.feetCubedLabel.attributedText = cubicFeetAttString
        // error label
        errorLabel.isHidden = true
        errorLabel2.isHidden = true
        // keeping track of current and previous rows
        selectedRow0 = 0
        selectedRow = 0
        timePicker.text = "Choose first available period"
        timePicker2.text = "Choose second available period"
        timePicker3.text = "Choose third available period"
        //picker view
        picker.delegate = self
        picker.dataSource = self
        days = [Dates(day: ["", "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"], hour: ["", "5", "6", "7", "8", "9", "10", "11", "12", "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11"])]
        createFirstPickerView()
        createSecondPickerView()
        createThirdPickerView()
        
        // availability labels
        availabilityOne.isHidden = true
        availabilityTwo.isHidden = true
        availabilityThree.isHidden = true
        
        //recording blur effect and settings blur window's effect to 0
        blurEffect = blurView.effect
        blurView.isHidden = true
        blurView.effect = nil
        
        //rounding corners of embeded views
        descriptionView.layer.cornerRadius = 27
        dimensionsView.layer.cornerRadius = 27
        availabilityView.layer.cornerRadius = 27
        
        if let user = Auth.auth().currentUser{
            Database.database().reference().child("Providers").child(user.uid).child("personalInfo").observe(.value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any]{
                    let ratingString = String(describing: dictionary["rating"]!)
                    let roundedRating = (Double(ratingString)! * 100).rounded()/100
                    let ratingTemp = String(format: "%.2f", roundedRating)
                    // MEDIUM
                    let fontRating: UIFont? = UIFont(name: "Dosis-Medium", size:14)
                    let ratingAttString:NSMutableAttributedString = NSMutableAttributedString(string: ratingTemp, attributes: [.font: fontRating!])
                    self.ratingLabel.attributedText = ratingAttString
                    
                    let nameString = String(describing: dictionary["Name"]!)
                    let nameFont: UIFont? = UIFont(name: "Dosis-Bold", size:18)
                    let nameAttString:NSMutableAttributedString = NSMutableAttributedString(string: nameString, attributes: [.font: nameFont!])
                    print("NAME ATT STRING: ", nameAttString)
                    self.nameLabel.attributedText = nameAttString
                    
                }
            })
        }
        
        //Hexagon SHape
        let lineWidth = CGFloat(7.0)
        let rect = CGRect(x: 0, y: 0.0, width: 90, height: 96)
        let sides = 6
        
        let path = roundedPolygonPath(rect: rect, lineWidth: lineWidth, sides: sides, cornerRadius: 8.0, rotationOffset: CGFloat(.pi / 2.0))
        
        let borderLayer = CAShapeLayer()
        borderLayer.frame = CGRect(x : 0.0, y : 0.0, width : path.bounds.width + lineWidth, height : path.bounds.height + lineWidth)
        borderLayer.path = path.cgPath
        borderLayer.lineWidth = lineWidth
        borderLayer.lineJoin = kCALineJoinRound
        borderLayer.lineCap = kCALineCapRound
        borderLayer.strokeColor = UIColor.black.cgColor
        borderLayer.fillColor = UIColor.white.cgColor
        
        _ = createImage(layer: borderLayer)
        
        
        
        profileImage.contentMode = .scaleAspectFill
        //        profileImage.layer.cornerRadius = 20
        profileImage.layer.masksToBounds = false
        profileImage.layer.mask = borderLayer
        profileImage.loadProfilePicture()
        // Do any additional setup after loading the view.
    }
    // animates in dimension pop up and adds blur
    func animateInDimensions() {
        self.view.addSubview(dimensionsView)
        dimensionsView.center = self.view.center
        dimensionsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        dimensionsView.alpha = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.dimensionsView.alpha = 1
            self.dimensionsView.transform = CGAffineTransform.identity
            }
    }
    // animates out dimension pop up and blur
    func animateOutDimensions(){
        UIView.animate(withDuration: 0.3, animations: {
            self.dimensionsView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.dimensionsView.alpha = 0
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }) { (success:Bool) in
            self.dimensionsView.removeFromSuperview()
        }
    }
    
    func animateInDescriptions() {
        self.view.addSubview(descriptionView)
        descriptionView.center = self.view.center
        descriptionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        descriptionView.alpha = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.descriptionView.alpha = 1
            self.descriptionView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutDescriptions() {
        UIView.animate(withDuration: 0.3, animations: {
            self.descriptionView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.descriptionView.alpha = 0
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }) { (success:Bool) in
            self.descriptionView.removeFromSuperview()
        }
    }
    
    func animateInAvailability(){
        self.view.addSubview(availabilityView)
        availabilityView.center = self.view.center
        availabilityView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        availabilityView.alpha = 0
        blurView.isHidden = false
        UIView.animate(withDuration: 0.3) {
            print(self.blurEffect)
            self.blurView.effect = self.blurEffect
            self.availabilityView.alpha = 1
            self.availabilityView.transform = CGAffineTransform.identity
        }
    }
    
    func animateOutAvailability(){
        UIView.animate(withDuration: 0.3, animations: {
            self.availabilityView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.availabilityView.alpha = 0
            self.blurView.effect = nil
            self.blurView.isHidden = true
        }) { (success:Bool) in
            self.availabilityView.removeFromSuperview()
        }
        //settings labels with timeslot info
        availabilityOne.isHidden = false
        availabilityTwo.isHidden = false
        availabilityThree.isHidden = false
        availabilityOne.text = timePicker.text
        availabilityTwo.text = timePicker2.text
        availabilityThree.text = timePicker3.text
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //parking switch
    @IBAction func parkingSwitch(_ sender: UISwitch) {
    }
    
    func checkValidTimes() -> Bool{
        if (selectedRow0 != 0 && selectedRow != 0) {
            return true
        }
        return false
    }
    var widthFeet: Int? = 0
    var heightFeet: Int? = 0
    var lengthFeet: Int? = 0
    
    //dimensions variables code
    @IBAction func widthSliderAction(_ sender: UISlider) {
        var widthLabelText = "Width: "
        widthLabelText += String(describing: Int(sender.value))
        widthLabelText += " ft."
        widthLabel.text = widthLabelText
        widthFeet = Int(sender.value)
        cubicFeetLabel.text = (String(describing: Int(heightFeet! * lengthFeet! * widthFeet!)))
        feetCubedLabel.isHidden = false
    }

    @IBAction func lengthSliderAction(_ sender: UISlider) {
        var lengthLabelText = "Length: "
        lengthLabelText += String(describing: Int(sender.value))
        lengthLabelText += " ft."
        lengthLabel.text = lengthLabelText
        lengthFeet = Int(sender.value)
        cubicFeetLabel.text = (String(describing: Int(heightFeet! * lengthFeet! * widthFeet!)))
        feetCubedLabel.isHidden = false
    }

    @IBAction func heightSliderAction(_ sender: UISlider) {
        var heightLabelText = "Height: "
        heightLabelText += String(describing: Int(sender.value))
        heightLabelText += " ft."
        heightLabel.text = heightLabelText
        heightFeet = Int(sender.value)
        cubicFeetLabel.text = (String(describing: Int(heightFeet! * lengthFeet! * widthFeet!)))
        feetCubedLabel.isHidden = false
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

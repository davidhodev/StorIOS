//
//  settingsCustomCellTableViewCell.swift
//
//
//  Created by David Ho on 6/4/18.
//

import UIKit

class settingsCustomCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var dropDownOne: UILabel! // Label
    @IBOutlet weak var dropDownTwo: UILabel!
    
    @IBOutlet weak var switchOne: UISwitch!
    @IBOutlet weak var switchTwo: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        switchOne.onTintColor = UIColor(red: 68/421, green: 140/421, blue: 253/421, alpha: 0.8)
        switchTwo.onTintColor = UIColor(red: 68/421, green: 140/421, blue: 253/421, alpha: 0.8)
        
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


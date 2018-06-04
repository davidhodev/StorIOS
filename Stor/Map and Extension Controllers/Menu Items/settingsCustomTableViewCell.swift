//
//  settingsCustomCellTableViewCell.swift
//
//
//  Created by David Ho on 6/4/18.
//

import UIKit

class settingsCustomCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var moreImage: UIImageView!
    @IBOutlet weak var settingsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


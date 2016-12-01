//
//  CustomSavedItemTableViewCell.swift
//  Chef it Up!
//
//  Created by Kory E King on 12/1/16.
//  Copyright © 2016 Kory E King. All rights reserved.
//

import UIKit

class CustomSavedItemTableViewCell: UITableViewCell {

    @IBOutlet weak var titleL: UILabel!
    @IBOutlet weak var recImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

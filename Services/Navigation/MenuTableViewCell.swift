//
//  MenuTableViewCell.swift
//  SWFBO
//
//  Created by Julien Guillan on 03/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet var enntryLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print(self.enntryLabel.text!)
        // Configure the view for the selected state
    }
    
}

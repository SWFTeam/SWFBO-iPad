//
//  APITableViewCell.swift
//  SWFBO
//
//  Created by Henri Gourgue on 03/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class APITableViewCell: UITableViewCell {
    
    @IBOutlet var statusApi: UILabel!
    @IBOutlet var statusMysql: UILabel!
    
    var mysql_status: String!
    var api_state: String!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setNewDisplay() {
        
        if(self.api_state == "running"){
            self.statusApi.textColor = UIColor.green
        } else {
            self.statusApi.textColor = UIColor.red
        }
        
        if(self.mysql_status == "running"){
            self.statusMysql.textColor = UIColor.green
        } else {
            self.statusMysql.textColor = UIColor.red
        }
        
        self.statusApi.text = self.api_state
        self.statusMysql.text = self.mysql_status
    }
    
}

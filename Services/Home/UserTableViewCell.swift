//
//  UserTableViewCell.swift
//  SWFBO
//
//  Created by Henri Gourgue on 01/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {
    
    var nbUsers: Int!
    var lastWeekUsers: [User]!
    var lastDayUsers: [User]!
    
    @IBOutlet var nbUsersLabel: UILabel!
    @IBOutlet var nbLastWeekUsers: UILabel!
    @IBOutlet var nbLastDayUsers: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func initialize(name: String, content: String, author: String){
        
    }
    
    func setDisplay() {
        if((self.nbUsers) != nil && (self.lastWeekUsers) != nil && (self.lastDayUsers) != nil){
            self.nbUsersLabel.text = String(self.nbUsers)
            self.nbLastWeekUsers.text = String(self.lastWeekUsers.count)
            self.nbLastDayUsers.text = String(self.lastDayUsers.count)
        }
    }
    
}

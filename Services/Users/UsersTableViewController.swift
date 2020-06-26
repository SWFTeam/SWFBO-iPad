//
//  UsersTableViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 26/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class UsersTableViewController: UITableViewController {
    
    var users: [User]!
        
    @IBOutlet var usersTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usersTableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UsersCell")
        self.usersTableView.dataSource = self
        self.usersTableView.delegate = self
        print(self.users)
    }
    
    class func newInstance(users: [User]) -> UsersTableViewController{
        let utvc = UsersTableViewController()
        utvc.users = users
        return utvc
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.users.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! UsersTableViewCell
        cell.firstnameLabel.text = self.users[indexPath.row].firstname
        print(cell)
        return cell
    }
    
}

//
//  UsersViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 26/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var users: [User]!
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate!
    
    @IBOutlet var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEdit))
        self.usersTableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UserViewCell")
        self.usersTableView.dataSource = self
        self.usersTableView.delegate = self
        self.dataSource = self.usersTableView.dataSource
        self.delegate = self.usersTableView.delegate
    }
    
    @objc func touchEdit() {
        UIView.animate(withDuration: 0.33){
            self.usersTableView.isEditing = !self.usersTableView.isEditing
        }
    }

    class func newInstance(users: [User]) -> UsersViewController{
        let utvc = UsersViewController()
        utvc.users = users
        utvc.dataSource = utvc
        utvc.delegate = utvc
        return utvc
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let user = self.users[indexPath.section]
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let spacing: CGFloat = 5
        return spacing
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let headerView = UIView()
           headerView.backgroundColor = UIColor.clear
           return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserViewCell", for: indexPath) as! UsersTableViewCell
        cell.firstnameLabel.text = self.users[indexPath.section].firstname
        cell.lastnameLabel.text = self.users[indexPath.section].lastname
        cell.layer.cornerRadius = 5
        cell.indentationLevel = 2
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(self.users[indexPath.section])
    }
}

//
//  UsersViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 26/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var user: User!
    var users: [User]!
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate!
    let uws: UserWebService = UserWebService()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet var usersTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEdit))
        self.usersTableView.register(UINib(nibName: "UsersTableViewCell", bundle: nil), forCellReuseIdentifier: "UserViewCell")
        self.usersTableView.dataSource = self
        self.usersTableView.delegate = self
        if #available(iOS 10.0, *) {
            self.usersTableView.refreshControl = refreshControl
        } else {
            self.usersTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.dataSource = self.usersTableView.dataSource
        self.delegate = self.usersTableView.delegate
    }
    
    @objc func touchEdit() {
        UIView.animate(withDuration: 0.33){
            self.usersTableView.isEditing = !self.usersTableView.isEditing
        }
    }
    
    @objc func refresh() {
        uws.getAllUsers(user: self.user) { (users) in
            DispatchQueue.main.async {
                self.users = users
                self.usersTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let user: User = self.users[indexPath.section]
        self.uws.deleteUser(user: self.user, userId: user.id!) { (code) in
            if(code == 200){
                DispatchQueue.main.sync {
                    self.usersTableView.beginUpdates()
                    self.users.remove(at: indexPath.section)
                    self.usersTableView.deleteSections(IndexSet(integer: indexPath.section), with: .automatic)
                    self.usersTableView.endUpdates()
                }
            }
        }
    }

    class func newInstance(user: User, users: [User]) -> UsersViewController{
        let utvc = UsersViewController()
        utvc.user = user
        utvc.users = users
        utvc.dataSource = utvc
        utvc.delegate = utvc
        return utvc
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
        let udvc = UserDetailsViewController.newInstance(user: self.user, usr: self.users[indexPath.section])
        self.navigationController?.pushViewController(udvc, animated: true)
    }
}

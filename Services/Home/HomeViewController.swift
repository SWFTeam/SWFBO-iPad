//
//  HomeViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 30/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userWebService: UserWebService = UserWebService()
    var user: User!
    @IBOutlet var userTableView: UITableView!
    var users: [User]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserHomeCell")
        self.userTableView.dataSource = self
        self.userTableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    class func newInstance(user: User) -> HomeViewController{
        let homeViewController = HomeViewController()
        homeViewController.user = user
        return homeViewController
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserHomeCell", for: indexPath) as! UserTableViewCell
        userWebService.getAllUsers(user: self.user, completion: { (users) in
            self.users = users
            cell.nbUsers = self.users.count
            cell.setDisplay()
            //Trier les utilisateurs en deux parties :
            // New registrations(7 last days): 80 | Last 24hrs logged-in: 70 / Last 7 days : 456
        })
        return cell
    }

}

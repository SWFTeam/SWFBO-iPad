//
//  MenuViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 03/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var menuTableView: UITableView!
    @IBOutlet var stackView: UIStackView!
    let db: DBHelper = DBHelper()
    let entries: [String] = ["Home", "Users", "Events", "Challenges", "Advices"]
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        self.menuTableView.dataSource = self // data list listener
        self.menuTableView.delegate = self // user events listener
        self.navigationItem.title = "Navigation"
        let settingsButton = UIBarButtonItem(title: String("\u{2699}\u{0000FE0E}"), style: .plain, target: self, action: #selector(settings))
        let font = UIFont.systemFont(ofSize: 28)
        let attr = [NSAttributedString.Key.font: font]
        settingsButton.setTitleTextAttributes(attr, for: .normal)
        self.navigationItem.leftBarButtonItem = settingsButton
    }
    
    @objc func settings() {
        let alert = UIAlertController(title: "API Endpoint", message: "SWF API endpoint:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Endpoint"
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak alert] (_) in
            let endpoint = alert?.textFields![0].text
            if(endpoint != ""){
                
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }

    class func newInstance(user: User) -> MenuViewController {
        let mvc = MenuViewController()
        mvc.user = user
        return mvc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.menuTableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell") as! MenuTableViewCell
        let entry = self.entries[indexPath.row]
        cell.entryLabel.text = entry
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.entries[indexPath.row]
        let navController = UINavigationController()
        /**
         *TODO
         *Place self.stackView.addArrangedSubview(view.view) only one tilme after switch statements
         */
        switch entry {
        case "Home":
            let user = self.user
            var homeView = HomeViewController()
            homeView = HomeViewController.newInstance(user: user!)
            /*homeView.userTableView.dataSource = homeView.userDataSource
            homeView.userTableView.delegate = homeView.userDelegate*/
            navController.viewControllers = [homeView]
            self.showDetailViewController(navController, sender: self)
            break
        case "Challenges":
            let challengeWebService: ChallengeWebService = ChallengeWebService()
            challengeWebService.getAllChallenges(token: self.user.token) { (challenges) in
                DispatchQueue.main.async {
                    let challengesView = ChallengesViewController.newInstance(user: self.user, challenges: challenges)
                    navController.viewControllers = [challengesView]
                    self.showDetailViewController(navController, sender: self)
                }
            }
            break
        case "Users":
            let uws = UserWebService()
            uws.getAllUsers(user: self.user) { (users) in
                DispatchQueue.main.async {
                    let usersView = UsersViewController.newInstance(user: self.user, users: users)
                    navController.viewControllers = [usersView]
                    self.showDetailViewController(navController, sender: self)
                }
            }
            
            break
        case "Events":
            let ews = EventWebService()
            ews.getAllEvents(user: self.user, completion: { (events) in
                DispatchQueue.main.sync {
                    let eventsView = EventsViewController.newInstance(user: self.user, events: events)
                    navController.viewControllers = [eventsView]
                    self.showDetailViewController(navController, sender: self)
                }
            })
            break
        case "Advices":
            let aws = AdviceWebService()
            aws.getAllAdvices(user: self.user) { (advices) in
                DispatchQueue.main.sync {
                    let advicesView = AdvicesViewController.newInstance(user: self.user, advices: advices)
                    navController.viewControllers = [advicesView]
                    self.showDetailViewController(navController, sender: self)
                }
            }
        default:
            break
        }
        
       // self.stackView.addArrangedSubview(view.view)
    }

}

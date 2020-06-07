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
    let challengeWebService: ChallengeWebService = ChallengeWebService()
    let entries: [String] = ["Home", "Users", "Events", "Challenges"]
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.menuTableView.register(UINib(nibName: "MenuTableViewCell", bundle: nil), forCellReuseIdentifier: "MenuTableViewCell")
        self.menuTableView.dataSource = self // data list listener
        self.menuTableView.delegate = self // user events listener
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
        /**
         *TODO
         *Place self.stackView.addArrangedSubview(view.view) only one tilme after switch statements
         */
        switch entry {
        case "Home":
            let user = db.selectWhereId(id: 1)
            var homeView = HomeViewController()
            homeView = HomeViewController.newInstance(user: user)
            /*homeView.userTableView.dataSource = homeView.userDataSource
            homeView.userTableView.delegate = homeView.userDelegate*/
            
            self.stackView.addSubview(homeView.view)
            break
        case "Challenges":
            challengeWebService.getAllChallenges(token: self.user.token) { (challenges) in
                DispatchQueue.main.async {
                   let viewTest = ChallengesViewController.newInstance(challenges: challenges)
                    self.stackView.addSubview(viewTest.view)
                    viewTest.challengesTableView.dataSource = viewTest.dataSource
                    viewTest.challengesTableView.delegate = viewTest.delegate
                }
                /*DispatchQueue.main.async {
                    let testView = ChallengesViewController.newInstance(challenges: challenges)
                    self.navigationController?.pushViewController(testView, animated: true)
                }*/
            }
            break
        case "Users":
            break
        case "Events":
            break
        default:
            break
        }
        
       // self.stackView.addArrangedSubview(view.view)
    }

}

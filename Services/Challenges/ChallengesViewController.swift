//
//  ChallengesViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 02/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var challengesTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    var challenges: [Challenge]!
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate!
    let cws: ChallengeWebService = ChallengeWebService()
    var user: User!
    
    enum Identifier: String{
        case challenges
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Challenges list"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEdit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchNew))
        self.challengesTableView.register(UINib(nibName: "ChallengeTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeTableViewCell")
        self.challengesTableView.dataSource = self // data list listener
        self.challengesTableView.delegate = self // user events listener
        if #available(iOS 10.0, *) {
            self.challengesTableView.refreshControl = refreshControl
        } else {
            self.challengesTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.dataSource = self.challengesTableView.dataSource
        self.delegate = self.challengesTableView.delegate
    }
    
    @objc func touchNew() {
        newChallenge()
    }
    
    @objc func touchEdit() {
        UIView.animate(withDuration: 0.33){
            self.challengesTableView.isEditing = !self.challengesTableView.isEditing
        }
    }
    
    @objc func refresh() {
        cws.getAllChallenges(token: self.user.token) { (challenges) in
            DispatchQueue.main.sync {
                print(self.challenges.count)
                self.challenges = challenges
                self.challengesTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    
    class func newInstance(user: User, challenges: [Challenge]) -> ChallengesViewController {
        let cvc = ChallengesViewController()
        cvc.challenges = challenges
        cvc.user = user
        cvc.dataSource = cvc
        cvc.delegate = cvc
        return cvc
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let challenge = self.challenges[indexPath.row]
        cws.deleteChallenge(user: self.user, challenge: challenge) { (resultCode) in
            print(resultCode)
            self.challenges.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.challengesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.challengesTableView.dequeueReusableCell(withIdentifier: "ChallengeTableViewCell", for: indexPath) as! ChallengeTableViewCell
        let entry = self.challenges[indexPath.row]
        cell.challNameLabel.text = entry.descriptions[0].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.challenges[indexPath.row]
        let dcvc = DetailsChallengeViewController.newInstance(user: self.user, challenge: entry)
        self.navigationController?.pushViewController(dcvc, animated: true)
    }
    
    func newChallenge(){
        let ncvc = NewChallengeViewController.newInstance(user: self.user)
        self.navigationController?.pushViewController(ncvc, animated: true)
    }
}

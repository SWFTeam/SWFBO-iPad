//
//  ChallengesViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 02/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class ChallengesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var challenges: [Challenge]!
    @IBOutlet var challengesTableView: UITableView!
    var dataSource: UITableViewDataSource?
    var delegate: UITableViewDelegate!
    let challengeWebService: ChallengeWebService = ChallengeWebService()
    var token: String!
    
    enum Identifier: String{
        case challenges
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEdit))
        self.challengesTableView.register(UINib(nibName: "ChallengeTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeTableViewCell")
        self.challengesTableView.dataSource = self // data list listener
        self.challengesTableView.delegate = self // user events listener
        
        self.dataSource = self.challengesTableView.dataSource
        self.delegate = self.challengesTableView.delegate
    }
    
    @objc func touchEdit() {
        UIView.animate(withDuration: 0.33){
            self.challengesTableView.isEditing = !self.challengesTableView.isEditing
        }
    }
    
    
    class func newInstance(token: String, challenges: [Challenge]) -> ChallengesViewController {
        let cvc = ChallengesViewController()
        cvc.challenges = challenges
        cvc.token = token
        cvc.dataSource = cvc
        cvc.delegate = cvc
        return cvc
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let challenges = self.challenges[indexPath.row]
       /* self.challengeWebService.removeScooter(scooter: scooter) { (success) in
            if success {
                self.scooters.remove(at: indexPath.row)
                DispatchQueue.main.sync {
                    self.tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }
        }*/
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
        let dcvc = DetailsChallengeViewController.newInstance(challenge: entry)
        self.navigationController?.pushViewController(dcvc, animated: true)
        print(self.navigationController.debugDescription)
        print("CLICKED", entry)
    }
}

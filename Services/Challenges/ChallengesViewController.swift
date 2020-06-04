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

    override func viewDidLoad() {
        super.viewDidLoad()
        self.challengesTableView.register(UINib(nibName: "ChallengeTableViewCell", bundle: nil), forCellReuseIdentifier: "ChallengeTableViewCell")
        self.challengesTableView.dataSource = self // data list listener
        self.challengesTableView.delegate = self // user events listener
    }
    
    class func newInstance(challenges: [Challenge]) -> ChallengesViewController {
        let cvc = ChallengesViewController()
        cvc.challenges = challenges
        return cvc
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return challenges.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.challengesTableView.dequeueReusableCell(withIdentifier: "ChallengeTableViewCell") as! ChallengeTableViewCell
        let entry = self.challenges[indexPath.row]
        cell.challNameLabel.text = entry.descriptions[0].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = self.challenges[indexPath.row]
        print(entry)
    }

}

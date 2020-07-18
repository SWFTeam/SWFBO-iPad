//
//  AdvicesViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 17/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class AdvicesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var advicesTableView: UITableView!
    var user: User!
    var advices: [Advice]!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.advicesTableView.delegate = self
        self.advicesTableView.dataSource = self
        self.advicesTableView.register(UINib(nibName: "AdviceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdviceTableViewCell")
    }
    
    class func newInstance(user: User, advices: [Advice]) -> AdvicesViewController {
        let avc = AdvicesViewController()
        avc.user = user
        avc.advices = advices
        return avc
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.advices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.advicesTableView.dequeueReusableCell(withIdentifier: "AdviceTableViewCell", for: indexPath) as! AdviceTableViewCell
        let entry = self.advices[indexPath.row]
        cell.adviceNameLabel.text = entry.descriptions[0].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let advc = AdviceDetailsViewController.newInstance(user: self.user, advice: self.advices[indexPath.row])
        navigationController?.pushViewController(advc, animated: true)
    }
}

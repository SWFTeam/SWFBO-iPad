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
    
    let refreshControl = UIRefreshControl()
    var user: User!
    var advices: [Advice]!
    let aws: AdviceWebService = AdviceWebService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Advices list"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEdit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchNew))
        self.advicesTableView.delegate = self
        self.advicesTableView.dataSource = self
        self.advicesTableView.register(UINib(nibName: "AdviceTableViewCell", bundle: nil), forCellReuseIdentifier: "AdviceTableViewCell")
        if #available(iOS 10.0, *) {
            self.advicesTableView.refreshControl = refreshControl
        } else {
            self.advicesTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc func touchNew() {
        newAdvice()
    }
    
    @objc func touchEdit() {
        UIView.animate(withDuration: 0.33){
            self.advicesTableView.isEditing = !self.advicesTableView.isEditing
        }
    }
    
    @objc override func refresh() {
        aws.getAllAdvices(user: self.user) { (advices) in
            DispatchQueue.main.sync {
                self.advices = advices
                self.advicesTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    class func newInstance(user: User, advices: [Advice]) -> AdvicesViewController {
        let avc = AdvicesViewController()
        avc.user = user
        avc.advices = advices
        return avc
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let advice = self.advices[indexPath.row]
        aws.deleteAdvice(user: self.user, advice: advice) { (resultCode) in
            self.advices.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.advicesTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
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
    
    func newAdvice() {
        let navc = NewAdviceViewController.newInstance(user: self.user)
        self.navigationController?.pushViewController(navc, animated: true)
    }
}

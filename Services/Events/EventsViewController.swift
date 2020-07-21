//
//  EventsViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 15/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class EventsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var eventsTableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    let ews: EventWebService = EventWebService()
    var events: [Event]!
    var user: User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Events list"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(touchEdit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(touchNew))
        self.eventsTableView.register(UINib(nibName: "EventTableViewCell", bundle: nil), forCellReuseIdentifier: "EventTableViewCell")
        if #available(iOS 10.0, *) {
            self.eventsTableView.refreshControl = refreshControl
        } else {
            self.eventsTableView.addSubview(refreshControl)
        }
        self.refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        self.eventsTableView.delegate = self
        self.eventsTableView.dataSource = self
    }
    
    @objc func touchNew() {
        newEvent()
    }
    
    @objc func touchEdit() {
        UIView.animate(withDuration: 0.33){
            self.eventsTableView.isEditing = !self.eventsTableView.isEditing
        }
    }
    
    @objc override func refresh() {
        ews.getAllEvents(user: self.user) { (events) in
            DispatchQueue.main.sync {
                self.events = events
                self.eventsTableView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    class func newInstance(user: User, events: [Event]) -> EventsViewController{
        let evc = EventsViewController()
        evc.events = events
        evc.user = user
        return evc
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let event = self.events[indexPath.row]
        ews.deleteEvent(user: self.user, event: event) { (resultCode) in
            self.events.remove(at: indexPath.row)
            DispatchQueue.main.async {
                self.eventsTableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let evc = EventDetailsViewController.newInstance(user: self.user, event: self.events[indexPath.row])
        self.navigationController?.pushViewController(evc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.eventsTableView.dequeueReusableCell(withIdentifier: "EventTableViewCell", for: indexPath) as! EventTableViewCell
        let entry = self.events[indexPath.row]
        if entry.descriptions.count > 0 {
            cell.nameLabel.text = entry.descriptions[0].title
        } else {
            cell.nameLabel.text = "No event in database"
        }
        
        return cell
    }
    
    func newEvent() {
        let nevc = NewEventViewController.newInstance(user: self.user)
        self.navigationController?.pushViewController(nevc, animated: true)
    }
}

//
//  HomeViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 30/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit
import Charts

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userWebService: UserWebService = UserWebService()
    var apiWebService: APIWebService = APIWebService()
    var chart: PieChartView = PieChartView()
    var user: User!
    @IBOutlet var userTableView: UITableView!
    @IBOutlet var apiTableView: UITableView!
    @IBOutlet var chartView: UIStackView!
    
    var userDataSource: UITableViewDataSource!
    var userDelegate: UITableViewDelegate!
    
    var apiDataSource: UITableViewDataSource!
    var apiDelegate: UITableViewDelegate!
    
    var users: [User]!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HEEEEEEEERERERERER+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++")
        self.userTableView.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserHomeCell")
        self.userTableView.dataSource = self
        self.userTableView.delegate = self
        self.userDataSource = self
        self.userDelegate = self
        
        self.apiTableView.register(UINib(nibName: "APITableViewCell", bundle: nil), forCellReuseIdentifier: "APICell")
        self.apiTableView.dataSource = self
        self.apiTableView.delegate = self
        self.apiDataSource = self
        self.apiDelegate = self

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
        
        if(tableView == userTableView){
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserHomeCell", for: indexPath) as! UserTableViewCell
            userWebService.getAllUsers(user: self.user, completion: { (users) in
                self.users = users
                cell.nbUsers = self.users.count
                //Trier les utilisateurs en deux parties :
                // New registrations(7 last days): 80 | Last 24hrs logged-in: 70 / Last 7 days : 456
                var lastWeekUsers = [User]()
                var lastDayUsers = [User]()
                for user in users {
                    if(self.getDiffInDays(from: user.created_at) <= 7){
                        lastWeekUsers.append(user)
                    }
                    if(self.getDiffInDays(from: user.last_login_at) < 1){
                        lastDayUsers.append(user)
                    }
                }
                
                self.chart.noDataText = "Aucune donnée à afficher."
                let values: [Int?] = [self.users.count, lastWeekUsers.count, lastDayUsers.count]
                self.setChart(values: values)
                self.chartView.addArrangedSubview(self.chart)
                
                if(!lastWeekUsers.isEmpty){
                    cell.lastWeekUsers = lastWeekUsers
                }
                if(!lastDayUsers.isEmpty){
                    cell.lastDayUsers = lastDayUsers
                } else {
                    /*DispatchQueue.main.async{
                        print("ERROR lastWeekUsers = nil")
                    }*/
                }
                cell.setDisplay()
            })
            return cell
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "APICell", for: indexPath) as! APITableViewCell
            self.apiWebService.getStatus(completion: { (status) in
                cell.mysql_status = status.mysql_status
                cell.api_state = status.api_state
                cell.setNewDisplay()
                })
            return cell
        }
    }
    
    func getDiffInDays(from: String) -> Int{
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = dateFormatter.date(from: from)
        let diffInDays = Calendar.current.dateComponents([.day], from: date!, to: now).day
        return diffInDays!
    }
    
    func setChart(values: [Int?]){
        
        let dataPoints: [String] = ["nbUsers", "nbLastWeekUsers", "nbLastDayUsers"]
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: Double(values[i]!), label: dataPoints[i], data: dataPoints[i] as AnyObject)
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = [UIColor.red, UIColor.gray, UIColor.blue]
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        self.chart.legend.font = UIFont(name: "Helvetica Neue", size: 16.0)!
        self.chart.entryLabelFont = UIFont(name: "Helvetica Neue", size: 17.0)!
        self.chart.data = pieChartData
    }
}

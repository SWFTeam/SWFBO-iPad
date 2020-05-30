//
//  HomeViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 30/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var user: User!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    class func newInstance(user: User) -> HomeViewController{
        let homeViewController = HomeViewController()
        homeViewController.user = user
        return homeViewController
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

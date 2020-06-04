//
//  DetailsChallengeViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 04/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class DetailsChallengeViewController: UIViewController {
    
    var challenge: Challenge!

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var titletextView: UITextField!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var descriptiontextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func newInstance(challenge: Challenge){
        self.idLabel.text = String(challenge.id)
        //self.titletextView.text = challenge.title
        
    }
}

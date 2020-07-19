//
//  UserDetailsViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 19/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var lastLoginLabel: UILabel!
    @IBOutlet var createdLabel: UILabel!
    @IBOutlet var firstnameTextField: UITextField!
    @IBOutlet var lastnameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var birthdayPicker: UIDatePicker!
    @IBOutlet var countryTextField: UITextField!
    @IBOutlet var cityTextField: UITextField!
    @IBOutlet var streetTextField: UITextField!
    @IBOutlet var zipcodeTextField: UITextField!
    @IBOutlet var nbHouseTextField: UITextField!
    @IBOutlet var complementTextView: UITextView!
    @IBOutlet var updateButton: UIButton!
    @IBOutlet var deleteButton: UIButton!
    @IBOutlet var setAdminButton: UIButton!
    
    var user: User!
    let uws: UserWebService = UserWebService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "User details"
        self.birthdayPicker.datePickerMode = UIDatePicker.Mode.date
        self.complementTextView.layer.borderWidth = 1
        self.complementTextView.layer.cornerRadius = 5
        self.setText()
    }
    
    class func newInstance(user: User) -> UserDetailsViewController {
        let udvc = UserDetailsViewController()
        udvc.user = user
        return udvc
    }
    
    func setText() {
        self.usernameLabel.text = self.user.firstname! + " " + self.user.lastname!
        self.lastLoginLabel.text = self.user.last_login_at
        self.createdLabel.text = self.user.created_at
        self.firstnameTextField.text = self.user.firstname
        self.lastnameTextField.text = self.user.lastname
        self.emailTextField.text = self.user.email
        //self.birthdayPicker.va
        self.countryTextField.text = self.user.address.country
        self.cityTextField.text = self.user.address.city
        self.streetTextField.text = self.user.address.street
        self.zipcodeTextField.text = String(self.user.address.zipCode)
        self.nbHouseTextField.text = String(self.user.address.nbHouse)
        self.complementTextView.text = self.user.address.complement
    }
}

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
    var usr: User!
    let uws: UserWebService = UserWebService()
    let aws: AddressWebService = AddressWebService()
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        if(self.usr.isAdmin){
            self.navigationItem.title = "User details (admin)"
        } else {
            self.navigationItem.title = "User details"
        }
        self.updateButton.addTarget(self, action: #selector(updateAction), for: .touchUpInside)
        self.deleteButton.addTarget(self, action: #selector(deleteAction), for: .touchUpInside)
        self.setAdminButton.addTarget(self, action: #selector(setAdminAction), for: .touchUpInside)
        self.birthdayPicker.datePickerMode = UIDatePicker.Mode.date
        self.complementTextView.layer.borderWidth = 1
        self.complementTextView.layer.cornerRadius = 5
        self.setText()
        self.setDate()
    }
    
    @objc func updateAction() {
        //self.usr.birthday = "31/12/1997"
        getNewValues()
        var usrResultCode = 0
        var addrResultCode = 0
        self.uws.updateUser(user: self.user, update_user: usr) { (resultCode) in
            usrResultCode = resultCode
            print(resultCode)
        }
        self.aws.updateAddress(user: self.user, address: self.usr.address) { (resultCode) in
            addrResultCode = resultCode
            print(resultCode)
        }
        /*
        while(addrResultCode != 200 && usrResultCode != 200){
            print("loading...")
        }*/
        print(usrResultCode, addrResultCode)
        
        if(usrResultCode == 200 && addrResultCode == 200){
            self.showToast(message: "User updated successfully: 200", font: .systemFont(ofSize: 12.0))
        } else {
            self.showToast(message: "Error during update: " + String(usrResultCode), font: .systemFont(ofSize: 12.0))
        }
    }
    
    @objc func deleteAction() {
        let alert = UIAlertController(title: "DANGER", message: "Delete user ?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.uws.deleteUser(user: self.user, userId: self.usr.id!) { (resultCode) in
                DispatchQueue.main.sync {
                    if(resultCode == 200){
                        self.showToast(message: "User deleted: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                    } else {
                        self.showToast(message: "Error during delete: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func setAdminAction() {
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 2
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    class func newInstance(user: User, usr: User) -> UserDetailsViewController {
        let udvc = UserDetailsViewController()
        udvc.user = user
        udvc.usr = usr
        return udvc
    }
    
    func setDate() {
        self.dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let date = removeTimeStamp(fromDate: dateFormatter.date(from: self.usr.birthday!)!)
        self.birthdayPicker.date = date
    }
    
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
    
    func setText() {
        self.usernameLabel.text = self.usr.firstname! + " " + self.usr.lastname!
        self.lastLoginLabel.text = self.usr.last_login_at
        self.createdLabel.text = self.usr.created_at
        self.firstnameTextField.text = self.usr.firstname
        self.lastnameTextField.text = self.usr.lastname
        self.emailTextField.text = self.usr.email
        self.countryTextField.text = self.usr.address.country
        self.cityTextField.text = self.usr.address.city
        self.streetTextField.text = self.usr.address.street
        self.zipcodeTextField.text = String(self.usr.address.zipCode)
        self.nbHouseTextField.text = String(self.usr.address.nbHouse)
        self.complementTextView.text = self.usr.address.complement
    }
    
    func getNewValues() {
        self.usr.firstname = self.firstnameTextField.text
        self.usr.lastname = self.lastnameTextField.text
        self.usr.email = self.emailTextField.text!
        self.dateFormatter.dateFormat = "dd/MM/yyyy"
        self.usr.birthday = self.dateFormatter.string(from: self.birthdayPicker.date)
        self.usr.address.country = self.countryTextField.text!
        self.usr.address.city = self.cityTextField.text!
        self.usr.address.street = self.streetTextField.text!
        self.usr.address.zipCode = Int(self.zipcodeTextField.text!) ?? self.usr.address.zipCode
        self.usr.address.nbHouse = Int(self.nbHouseTextField.text!) ?? self.usr.address.nbHouse
        self.usr.address.complement = self.complementTextView.text
    }
}

//
//  DetailsChallengeViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 04/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class DetailsChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    var challenge: Challenge!
    var countryCodes: [String] = [String]()
    var selectedCountryCode: String!
    var user: User!
    let cws: ChallengeWebService = ChallengeWebService()
    var index: Int = 0
    var keyboardVisible = false

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var countryCodePicker: UIPickerView!
    @IBOutlet var expTextField: UITextField!
    
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
        self.navigationItem.title = "Challenge"
        self.countryCodePicker.delegate = self
        self.countryCodePicker.dataSource = self
        self.expTextField.keyboardType = .numberPad
        setDisplay()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.keyboardVisible == true {
            self.view.endEditing(true) // close all user interaction
            self.keyboardVisible = false
        }
    }
    
    class func newInstance(user: User, challenge: Challenge) -> DetailsChallengeViewController{
        let dcvc = DetailsChallengeViewController()
        dcvc.challenge = challenge
        dcvc.user = user
        return dcvc
    }
    
    func setDisplay(){
        self.challenge.descriptions.forEach { (descr) in
            self.countryCodes.append(descr.countryCode)
        }
        self.expTextField.text = String(self.challenge.experience)
        setText(index: self.index)
    }
    
    @objc func update() {
        self.challenge.descriptions[self.index].description = self.descriptionTextView.text!
        self.challenge.descriptions[self.index].title = self.titleTextField.text!
        self.challenge.descriptions[self.index].name = self.nameTextView.text!
        self.challenge.experience = Int(self.expTextField.text!) ?? 0
        cws.updateChallenge(token: self.user.token, challenge: self.challenge) { (resCode) in
            DispatchQueue.main.sync {
                if resCode == 200 {
                    self.showToast(message: "Updated successfully: " + String(resCode), font: .systemFont(ofSize: 12.0))
                } else {
                    self.showToast(message: "Error during update: " + String(resCode), font: .systemFont(ofSize: 12.0))
                }
            }
        }
    }
    
    func setText(index: Int){
        self.idLabel.text = self.challenge.descriptions[index].title + " (" + String(self.challenge.id) + ")"
        self.titleTextField.text = self.challenge.descriptions[index].title
        self.nameTextView.text = self.challenge.descriptions[index].name
        self.descriptionTextView.text = self.challenge.descriptions[index].description
        self.selectedCountryCode = self.challenge.descriptions[index].countryCode
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountryCode = self.countryCodes[row]
        setText(index: row)
        self.index = row
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryCodes[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryCodes.count
    }
}

extension DetailsChallengeViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.keyboardVisible = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.keyboardVisible = false
        return false
    }
}

//
//  AdviceDetailsViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 18/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class AdviceDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var countryCodePicker: UIPickerView!
    @IBOutlet var titleTextView: UITextField!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    var countryCodes: [String] = []
    var selectedCountryCode: String!
    var index: Int = 0;
    
    var user: User!
    var advice: Advice!
    
    let aws: AdviceWebService = AdviceWebService()
    
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(update))
        
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
        
        self.countryCodePicker.dataSource = self
        self.countryCodePicker.delegate = self
        self.navigationItem.title = "Advice"
        
        setDisplay()
    }
    
    class func newInstance(user: User, advice: Advice) -> AdviceDetailsViewController {
        let advc = AdviceDetailsViewController()
        advc.user = user
        advc.advice = advice
        return advc
    }
    
    func setDisplay() {
        self.advice.descriptions.forEach { (description) in
            self.countryCodes.append(description.countryCode)
            print(description.countryCode)
        }
        setText(index: self.index)
    }
    
    @objc func update() {
        self.advice.descriptions[self.index].description = self.descriptionTextView.text!
        self.advice.descriptions[self.index].title = self.titleTextView.text!
        self.advice.descriptions[self.index].name = self.nameTextView.text!
        aws.updateAdvice(user: self.user, advice: self.advice) { (resCode) in
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
        self.titleLabel.text = self.advice.descriptions[index].title + " (" + String(self.advice.id) + ")"
        self.titleTextView.text = self.advice.descriptions[index].title
        self.nameTextView.text = self.advice.descriptions[index].name
        self.descriptionTextView.text = self.advice.descriptions[index].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountryCode = self.countryCodes[row]
        setText(index: row)
        self.index = row
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryCodes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryCodes[row]
    }
}

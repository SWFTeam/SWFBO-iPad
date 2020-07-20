//
//  EventDetailsViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 16/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class EventDetailsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var titleTextView: UITextField!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var countryCodesPicker: UIPickerView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var experienceTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    
    let ews = EventWebService()
    let aws = AddressWebService()
    var user: User!
    var event: Event!
    var address: Address!
    var countryCodes: [String] = []
    var selectedCountryCode: String!
    var keyboardVisible = false
    var index: Int = 0
    
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
        self.countryCodesPicker.delegate = self
        self.countryCodesPicker.dataSource = self
        
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
        
        setDisplay()
    }
    
    @objc func update() {
        self.event.descriptions[self.index].description = self.descriptionTextView.text!
        self.event.descriptions[self.index].title = self.titleTextView.text!
        self.event.descriptions[self.index].name = self.nameTextView.text!
        self.ews.updateEvent(user: self.user, event: self.event) { (resultCode) in
            DispatchQueue.main.sync {
                if(resultCode == 200){
                    self.showToast(message: "Updated successfully: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                } else {
                    self.showToast(message: "Error during update: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                }
            }
        }
    }
    
    class func newInstance(user: User, event: Event) -> EventDetailsViewController{
        let edvc = EventDetailsViewController()
        edvc.user = user
        edvc.event = event
        return edvc
    }
    
    func setDisplay() {
        self.event.descriptions.forEach { (descr) in
            self.countryCodes.append(descr.countryCode)
        }
        setText(index: self.index)
    }
    
    func setText(index: Int){
        self.titleLabel.text = self.event.descriptions[index].title + " (" + String(self.event.id) + ")"
        self.titleTextView.text = self.event.descriptions[index].title
        self.nameTextView.text = self.event.descriptions[index].name
        self.descriptionTextView.text = self.event.descriptions[index].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCountryCode = self.countryCodes[row]
        self.index = row
        setText(index: self.index)
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

extension UIViewController {

func showToast(message : String, font: UIFont) {

    let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 200, height: 35))
    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    toastLabel.textColor = UIColor.white
    toastLabel.font = font
    toastLabel.textAlignment = .center;
    toastLabel.text = message
    toastLabel.alpha = 1.0
    toastLabel.layer.cornerRadius = 10;
    toastLabel.clipsToBounds  =  true
    self.view.addSubview(toastLabel)
    UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
         toastLabel.alpha = 0.0
    }, completion: {(isCompleted) in
        toastLabel.removeFromSuperview()
    })
} }

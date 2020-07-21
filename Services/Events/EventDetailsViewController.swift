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
    @IBOutlet var addCountryCode: UIButton!
    
    let ews = EventWebService()
    let aws = AddressWebService()
    var user: User!
    var event: Event!
    var address: Address!
    var countryCodes: [String] = []
    var selectedCountryCode: String!
    var keyboardVisible = false
    var index: Int = 0
    var selectedCode: String!
    var descriptions: [Description] = []
    
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
        
        self.addCountryCode.addTarget(self, action: #selector(addCountryCodeAction), for: .touchUpInside)
        
        self.countryCodesPicker.delegate = self
        self.countryCodesPicker.dataSource = self
        
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
        
        setDisplay()
        self.selectedCode = self.event.descriptions[0].countryCode
        addDescription(countryCode: self.event.descriptions[0].countryCode)
    }
    
    @objc func addCountryCodeAction() -> Void {
        let alert = UIAlertController(title: "Add countryCode", message: "New countryCode", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "CountryCode"
        }
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { [weak alert] (_) in
            var code = alert?.textFields![0].text
            if(code != ""){
                code = code!.uppercased()
                self.countryCodes.append(code!)
                self.countryCodesPicker.reloadAllComponents()
                self.selectedCode = code
            }
        }))
        self.present(alert, animated: true, completion: nil)
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
    
    func addDescription(countryCode: String){
        if(self.titleTextView.text != "" && self.nameTextView.text != "" && self.descriptionTextView.text != "" && countryCode != ""){
            //Remove from descriptions table if already in it
            var index: Int = 0
            for des in self.descriptions {
                if(des.countryCode == countryCode){
                    self.descriptions.remove(at: index)
                }
                index += 1
            }
            let description = getDescription()
            self.descriptions.append(description)
            self.showToast(message: "Saved.", font: .systemFont(ofSize: 12.0))
        } else {
            self.showToast(message: "Missing parameter(s)", font: .systemFont(ofSize: 12.0))
        }
    }
    
    func getDescription() -> Description {
        let countryCode = self.selectedCode;
        let title = self.titleTextView.text
        let name = self.nameTextView.text
        let descr = self.descriptionTextView.text
        let description = Description(id: 0, countryCode: countryCode!, title: title!, name: name!, descr: descr!, type: "event")
        return description
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
    
    func setDisplay(description: Description){
        self.titleTextView.text = description.title
        self.nameTextView.text = description.name
        self.descriptionTextView.text = description.description
    }
    
    func clearFields(){
        self.titleTextView.text = ""
        self.nameTextView.text = ""
        self.descriptionTextView.text = ""
    }
    
    func setText(index: Int){
        self.titleLabel.text = self.event.descriptions[index].title + " (" + String(self.event.id) + ")"
        self.titleTextView.text = self.event.descriptions[index].title
        self.nameTextView.text = self.event.descriptions[index].name
        self.descriptionTextView.text = self.event.descriptions[index].description
        self.experienceTextField.text = String(self.event.experience)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.index = row
        self.selectedCode = self.event.descriptions[row].countryCode
        setDisplay()
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

//
//  NewEventViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 18/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class NewEventViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet var countryCodePicker: UIPickerView!
    @IBOutlet var beginDatePicker: UIDatePicker!
    @IBOutlet var endDatePicker: UIDatePicker!
    @IBOutlet var addCountryCodeButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var expTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var addAddress: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    var user: User!
    let ews: EventWebService = EventWebService()
    var countryCodes: [String] = ["FR", "GB"]
    var selectedCode: String!
    var descriptions: [Description] = []
    var address: Address!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create new event"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        self.countryCodePicker.delegate = self
        self.countryCodePicker.dataSource = self
        self.selectedCode = self.countryCodes[0]
        self.expTextField.keyboardType = .numberPad
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
        self.beginDatePicker.datePickerMode = UIDatePicker.Mode.date
        self.endDatePicker.datePickerMode = UIDatePicker.Mode.date
        
        self.addAddress.addTarget(self, action: #selector(addAddressAction), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveDescription), for: .touchUpInside)
        self.createButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
    }

    class func newInstance(user: User) -> NewEventViewController {
        let nevc = NewEventViewController()
        nevc.user = user
        return nevc
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
    
    @objc func addAddressAction() {
        let alert = UIAlertController(title: "New Address", message: "Set address for this event:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            //0
            textField.placeholder = "Country"
        }
        alert.addTextField { (textField) in
            //1
            textField.placeholder = "City"
        }
        alert.addTextField { (textField) in
            //2
            textField.placeholder = "Street"
        }
        alert.addTextField { (textField) in
            //3
            textField.placeholder = "ZipCode"
        }
        alert.addTextField { (textField) in
            //4
            textField.placeholder = "House number"
        }
        alert.addTextField { (textField) in
            //5
            textField.placeholder = "Complement"
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
            
        }))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
            alert.textFields?.forEach({ (textField) in
                if(textField.text == ""){
                    
                }
            })
            let country = alert.textFields![0].text
            let city = alert.textFields![1].text
            let street = alert.textFields![2].text
            let zipCode = Int(alert.textFields![3].text!) ?? 0
            let houseNumber = Int(alert.textFields![4].text!) ?? 0
            let complement = alert.textFields![5].text
            self.address = Address(id: 0, country: country!, city: city!, street: street!, zipCode: zipCode, nbHouse: houseNumber, complement: complement!)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func saveDescription() -> Void {
        addDescription(countryCode: selectedCode)
    }
    
    @objc func createAction() {
        guard self.address != nil else {
            self.showToast(message: "Missing event's address", font: .systemFont(ofSize: 12.0))
            return
        }
        if (verifyInput()){
            let exp = Int(self.expTextField.text!) ?? 0
            //let tmp_address: Address = Address(id: 0, country: "France", city: "Saint-Aubin", street: "7 rue du vieux lavoir", zipCode: 91190, nbHouse: 7, complement: "")
            let beginDate = getDate(which: "begin")
            let endDate = getDate(which: "end")
            let event: Event = Event(id: 0, date_start: beginDate, date_end: endDate, experience: exp, descriptions: self.descriptions, address: self.address)
            ews.createEvent(user: self.user, event: event) { (resultCode) in
                DispatchQueue.main.sync {
                    if resultCode == 201 {
                        self.showToast(message: "Created successfully: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showToast(message: "Error during creation: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                    }
                }
            }
        } else {
            self.showToast(message: "Missing parameters", font: .systemFont(ofSize: 12.0))
        }
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
                self.countryCodePicker.reloadAllComponents()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func verifyInput() -> Bool {
        if(self.titleTextField.text == "" || self.nameTextField.text == "" || self.expTextField.text == "" || self.descriptionTextView.text == ""){
            return false
        } else {
            return true
        }
    }
    
    func getDescription() -> Description {
        let countryCode = self.selectedCode;
        let title = self.titleTextField.text
        let name = self.nameTextField.text
        let descr = self.descriptionTextView.text
        let description = Description(id: 0, countryCode: countryCode!, title: title!, name: name!, descr: descr!, type: "event")
        return description
    }
    
    func addDescription(countryCode: String){
        if(self.titleTextField.text != "" && self.nameTextField.text != "" && self.descriptionTextView.text != "" && countryCode != ""){
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
    
    func setDisplay(description: Description){
        self.titleTextField.text = description.title
        self.nameTextField.text = description.name
        self.descriptionTextView.text = description.description
    }
    
    func clearFields(){
        self.titleTextField.text = ""
        self.nameTextField.text = ""
        self.descriptionTextView.text = ""
    }
    
    func getDate(which: String) -> String {
        var datePicker: UIDatePicker!
        if which == "begin" {
            datePicker = self.beginDatePicker
        } else if which == "end" {
            datePicker = self.endDatePicker
        }
        datePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        let selectedDate = dateFormatter.string(from: datePicker.date)
        return selectedDate
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
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let description = getDescription()
        if !self.descriptions.contains(description){
            let alert = UIAlertController(title: "Careful", message: "Not saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
                self.countryCodePicker.selectRow(self.countryCodes.firstIndex(of: description.countryCode)!, inComponent: component, animated: true)
                return
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (_) in
                
                
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.selectedCode = self.countryCodes[row]
            clearFields()
            for description in self.descriptions {
                if(description.countryCode == self.countryCodes[row]){
                    setDisplay(description: description)
                }
            }
        }
    }
}

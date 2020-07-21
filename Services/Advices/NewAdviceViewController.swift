//
//  NewAdviceViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 20/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class NewAdviceViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var countryCodePicker: UIPickerView!
    @IBOutlet var addCountryCodeButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    var user: User!
    var countryCodes: [String] = ["FR", "GB"]
    var descriptions: [Description] = []
    var selectedCode: String!
    let aws: AdviceWebService = AdviceWebService()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create new advice"
        self.countryCodePicker.delegate = self
        self.countryCodePicker.dataSource = self
        
        self.selectedCode = self.countryCodes[0]
        
        self.saveButton.addTarget(self, action: #selector(saveDescription), for: .touchUpInside)
        self.createButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        
        self.descriptionTextView.layer.borderWidth = 1
        self.descriptionTextView.layer.cornerRadius = 5
    }
    
    class func newInstance(user: User) -> NewAdviceViewController{
        let navc = NewAdviceViewController()
        navc.user = user
        return navc
    }
    
    @objc func saveDescription() -> Void {
        addDescription(countryCode: selectedCode)
    }
    
    @objc func createAction() {
        if (self.descriptions.count > 0){
            let advice = Advice(id: 0, descriptions: self.descriptions)
            aws.createAdvice(user: self.user, advice: advice) { (resultCode) in
                DispatchQueue.main.sync {
                    if(resultCode == 200){
                        self.showToast(message: "Advice created.", font: .systemFont(ofSize: 12.0))
                    } else {
                        self.showToast(message: "Error during creation: " + String(resultCode), font: .systemFont(ofSize: 12.0))
                    }
                }
            }
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
    
    func getDescription() throws -> Description {
        guard let countryCode = self.selectedCode,
            let title = self.titleTextField.text,
            let name = self.nameTextField.text,
            let descr = self.descriptionTextView.text else {
                throw DataError.runtimeError("Description parameter cannot be nil")
        }
        let description = Description(id: 0, countryCode: countryCode, title: title, name: name, descr: descr, type: "advice")
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
            var description: Description!
            do {
                description = try getDescription()
            } catch {
                print("Error: Description cannot be nil")
            }
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
        var description: Description!
        do {
            description = try getDescription()
        }  catch {
            print("Error: Description parameters cannot be nil")
        }
        if !self.descriptions.contains(description){
            let alert = UIAlertController(title: "Careful", message: "Not saved", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Stay", style: .default, handler: { (_) in
                let previousIndex = self.countryCodes.firstIndex(of: description.countryCode)!
                //self.addDescription(countryCode: self.countryCodes[previousIndex])
                self.countryCodePicker.selectRow(previousIndex, inComponent: component, animated: true)
            }))
            alert.addAction(UIAlertAction(title: "Abort", style: .destructive, handler: { (_) in
                self.clearFields()
                self.selectedCode = self.countryCodes[row]
                for description in self.descriptions {
                    if(description.countryCode == self.countryCodes[row]){
                        self.setDisplay(description: description)
                    }
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.selectedCode = self.countryCodes[row]
            clearFields()
            for description in self.descriptions {
                if(description.countryCode == self.countryCodes[row]){
                    print(description.title)
                    setDisplay(description: description)
                }
            }
        }
    }
}

extension UIViewController {
    enum DataError: Error {
        case runtimeError(String)
    }
}

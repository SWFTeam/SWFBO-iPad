//
//  NewChallengeViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 14/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class NewChallengeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var descriptionTextField: UITextView!
    @IBOutlet var addCountryCodeButton: UIButton!
    @IBOutlet var countryCodePicker: UIPickerView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    
    var user: User!
    let cws: ChallengeWebService = ChallengeWebService()
    var countryCodes: [String] = ["FR", "GB"]
    var selectedCode: String!
    var descriptions: [Description] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Create new challenge"
        self.addCountryCodeButton.addTarget(self, action: #selector(addCountryCodeAction), for: .touchUpInside)
        self.saveButton.addTarget(self, action: #selector(saveDescription), for: .touchUpInside)
        self.createButton.addTarget(self, action: #selector(createAction), for: .touchUpInside)
        self.countryCodePicker.delegate = self
        self.countryCodePicker.dataSource = self
        self.descriptionTextField.layer.borderWidth = 1
        self.descriptionTextField.layer.cornerRadius = 5
        self.selectedCode = self.countryCodes[0]
    }
    
    class func newInstance(user: User) -> NewChallengeViewController{
        let ncvc = NewChallengeViewController()
        ncvc.user = user
        return ncvc
    }
    
    @objc func createAction(){
        let challenge = Challenge(id: 0, descriptions: self.descriptions)
        cws.createChallenge(token: self.user.token, challenge: challenge) { (resultCode) in
            print(resultCode)
        }
    }
    
    @objc func saveDescription() -> Void {
        addDescription(countryCode: selectedCode)
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
    
    func addDescription(countryCode: String){
        if(self.titleTextField.text != "" && self.nameTextField.text != "" && self.descriptionTextField.text != "" && countryCode != ""){
            //Remove from descriptions table if already in it
            var index: Int = 0
            for des in self.descriptions {
                if(des.countryCode == countryCode){
                    self.descriptions.remove(at: index)
                }
                index += 1
            }
            let title = self.titleTextField.text
            let name = self.nameTextField.text
            let descr = self.descriptionTextField.text
            let description = Description(id: 0, countryCode: countryCode, title: title!, name: name!, descr: descr!, type: "challenge")
            self.descriptions.append(description)
        }
    }
    
    func setDisplay(description: Description){
        self.titleTextField.text = description.title
        self.nameTextField.text = description.name
        self.descriptionTextField.text = description.description
    }
    
    func clearFields(){
        self.titleTextField.text = ""
        self.nameTextField.text = ""
        self.descriptionTextField.text = ""
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.countryCodes[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.selectedCode = self.countryCodes[row]
        print(self.countryCodes[row])
        clearFields()
        for description in self.descriptions {
            if(description.countryCode == self.countryCodes[row]){
                setDisplay(description: description)
                print(description.countryCode)
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.countryCodes.count
    }

}

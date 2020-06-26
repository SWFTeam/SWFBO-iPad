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

    @IBOutlet var idLabel: UILabel!
    @IBOutlet var nameTextView: UITextField!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet var countryCodePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryCodePicker.delegate = self
        self.countryCodePicker.dataSource = self
        setDisplay()
        // Do any additional setup after loading the view.
    }
    
    class func newInstance(challenge: Challenge) -> DetailsChallengeViewController{
        let dcvc = DetailsChallengeViewController()
        dcvc.challenge = challenge
        return dcvc
    }
    
    func setDisplay(){
        self.challenge.descriptions.forEach { (descr) in
            self.countryCodes.append(descr.countryCode)
        }
        setText(index: 0)
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

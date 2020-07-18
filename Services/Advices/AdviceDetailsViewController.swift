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
    
    var countryCodes: [String] = []
    var selectedCountryCode: String!
    var index: Int = 0;
    
    var user: User!
    var advice: Advice!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.countryCodePicker.dataSource = self
        self.countryCodePicker.delegate = self
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
        }
        self.titleLabel.text = self.advice.descriptions[0].title
        self.titleTextView.text = self.advice.descriptions[0].title
        self.nameTextView.text = self.advice.descriptions[0].name
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

//
//  VolkareWoundSelectViewController.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

protocol VolkareWoundSelectDelegate: class {
    func createDeck(numberOfWounds: Int)
}

class VolkareWoundSelectViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var woundPickerView: UIPickerView!
    weak var delegate: VolkareWoundSelectDelegate?
    
    let maximumWounds = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
        woundPickerView.dataSource = self
        woundPickerView.delegate = self
        woundPickerView.selectRow(15, inComponent: 0, animated: false)
        updateUI()
    }
    
    func updateUI() {
        woundPickerView.reloadAllComponents()
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        return self.maximumWounds + 1
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }

    @IBAction func createDeck() {
        if let d = delegate {
            d.createDeck(woundPickerView.selectedRowInComponent(0))
        }
    }
}

//
//  ReputationViewController.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

class ReputationViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var rawLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!
    
    var model = ReputationModel.initFromUserDefaults() as? ReputationModel ??  ReputationModel()
    var lastSenderValue = 0.0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let icon = Utils.imageFromText("♥️", font: UIFont(name: "Helvetica", size: 28)!, maxWidth: CGFloat(64), color: UIColor.blueColor())
        tabBarItem = UITabBarItem(title: "Reputation", image: icon, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        stepper.minimumValue = Double(self.model.minimumRawValue)
        stepper.maximumValue = Double(self.model.maximumRawValue)
        stepper.value = Double(self.model.rawReputation)
        updateUI()
    }
    
    @IBAction func changeReputation(sender: UIStepper) {
        if lastSenderValue < sender.value {
            self.model.incrementReputation()
        } else {
            self.model.decrementReputation()
        }
        lastSenderValue = sender.value
        updateUI()
    }
    
    func updateUI() {
        valueLabel.text = "\(self.model.currentReputation) \(self.emojiForCurrentValue())"
        rawLabel.text = "Raw Reputation: \(self.model.rawReputation)"
    }
    
    private func emojiForCurrentValue() -> String {
        if self.model.currentReputation == "X" {
            return "😡"
        }
        let numeric = Int(self.model.currentReputation)
        switch (numeric) {
        case _ where numeric < -3: return "😤"
        case _ where numeric < -2: return "😩"
        case _ where numeric < 0: return "😟"
        case _ where numeric == 0: return "😐"
        case _ where numeric <= 2: return "🙂"
        case _ where numeric < 5: return "😃"
        case _ where numeric >= 5: return "😍"
        default: return "😶"
        }
    }
    
}

//
//  VolkareDeckViewController.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

protocol VolkareDeckDelegate: class {
    func drawNextCard()
}

protocol VolkareDeckDataSource: class {
    func currentCard() -> VolkareCard?
    func cardsRemaining() -> Int
}

class VolkareDeckViewController: UIViewController {

    @IBOutlet weak var currentCardLabel: UILabel!
    @IBOutlet weak var cardsRemainingLabel: UILabel!
    weak var delegate: VolkareDeckDelegate?
    weak var dataSource: VolkareDeckDataSource?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        if let ds = self.dataSource {
            currentCardLabel.text = ds.currentCard()?.rawValue
            cardsRemainingLabel.text = "Cards Remaining: \(ds.cardsRemaining())"
        }
    }
    
    @IBAction func drawNextCard() {
        if let d = self.delegate {
            d.drawNextCard()
            updateUI()
        }
    }
}

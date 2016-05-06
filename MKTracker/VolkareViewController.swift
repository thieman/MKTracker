//
//  VolkareViewController.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

class VolkareViewController: UIViewController, VolkareWoundSelectDelegate, VolkareDeckDelegate, VolkareDeckDataSource {
    
    var woundSelectController: VolkareWoundSelectViewController?
    var deckController: VolkareDeckViewController?
    
    var model = VolkareDeckModel.initFromUserDefaults() as? VolkareDeckModel
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let icon = Utils.imageFromText("⚔", font: UIFont(name: "Helvetica", size: 24)!, maxWidth: CGFloat(64), color: UIColor.blueColor())
        tabBarItem = UITabBarItem(title: "Volkare", image: icon, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if model == nil {
            renderWoundSelectSubview()
        } else {
            renderDeckSubview()
        }
    }
    
    private func renderWoundSelectSubview() {
        woundSelectController = VolkareWoundSelectViewController()
        let wsc = woundSelectController!
        wsc.willMoveToParentViewController(self)
        self.addChildViewController(wsc)
        self.view.addSubview(wsc.view)
        
        var subviewFrame = wsc.view.frame
        subviewFrame.size.width = self.view.frame.size.width - 20
        wsc.view.frame = subviewFrame
        wsc.view.center = CGPointMake(self.view.frame.size.width / 2,
                                      self.view.frame.size.height / 2)
        
        wsc.didMoveToParentViewController(self)
        wsc.delegate = self
    }
    
    private func renderDeckSubview() {
        deckController = VolkareDeckViewController()
        let dc = deckController!
        dc.delegate = self
        dc.dataSource = self
        
        dc.willMoveToParentViewController(self)
        self.addChildViewController(dc)
        self.view.addSubview(dc.view)
        
        var subviewFrame = dc.view.frame
        subviewFrame.size.width = self.view.frame.size.width - 20
        dc.view.frame = subviewFrame
        dc.view.center = CGPointMake(self.view.frame.size.width / 2,
                                     self.view.frame.size.height / 2)
        
        dc.didMoveToParentViewController(self)
    }
    
    func createDeck(numberOfWounds: Int) {
        if let wsc = woundSelectController {
            wsc.willMoveToParentViewController(nil)
            wsc.view.removeFromSuperview()
            wsc.removeFromParentViewController()
            
            model = VolkareDeckModel(numberOfWounds: numberOfWounds)
            renderDeckSubview()
        }
    }
    
    func drawNextCard() {
        if let m = self.model {
            m.popNextCard()
        }
    }
    
    func currentCard() -> VolkareCard? {
        return self.model?.lastCardDrawn
    }
    
    func cardsRemaining() -> Int {
        return self.model?.cardsRemaining ?? 0
    }
    
}

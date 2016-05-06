//
//  VolkareDeckModel.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import Foundation
import GameKit

enum VolkareCard: String {
    case Wound, RedAction, BlueAction, GreenAction, WhiteAction, RedSpell, BlueSpell, GreenSpell, WhiteSpell
}

class VolkareDeckModel: PersistableModel {
    
    let startingValues: [VolkareCard: Int] = [
        .RedAction: 4,
        .BlueAction: 4,
        .GreenAction: 4,
        .WhiteAction: 4,
        .RedSpell: 1,
        .BlueSpell: 1,
        .GreenSpell: 1,
        .WhiteSpell: 1
    ]

    static var persistenceKey = "volkareDeckModel"
    private var initialized = false
    private var totalWounds = 0
    private var _lastCardDrawn: VolkareCard?
    private var remaining: [VolkareCard]
    private var discarded: [VolkareCard]
    
    init(numberOfWounds: Int) {
        self.totalWounds = numberOfWounds
        
        // Create initial deck
        remaining = [VolkareCard]()
        for (type, number) in self.startingValues {
            for _ in 0..<number {
                remaining.append(type)
            }
        }
        for _ in 0..<numberOfWounds {
            remaining.append(.Wound)
        }
        let raws = remaining.map { $0.rawValue }
        let shuffledRaws = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(raws)
        remaining = shuffledRaws.map { VolkareCard(rawValue: $0 as! String)! }
        discarded = [VolkareCard]()
        
        self.initialized = true
        self.persist()
    }
    
    required init(fromJSONDict dict: [String : AnyObject]) {
        self.initialized = dict["initialized"] as! Bool
        self.totalWounds = dict["totalWounds"] as! Int
        self._lastCardDrawn = VolkareCard(rawValue: (dict["_lastCardDrawn"] as! String))
        self.remaining = (dict["remaining"] as! [String]).map { VolkareCard(rawValue: $0)! }
        self.discarded = (dict["discarded"] as! [String]).map { VolkareCard(rawValue: $0)! }
    }
    
    func dictForJSON() -> [String : AnyObject] {
        let result: [String: AnyObject]
        result = [
            "initialized": self.initialized,
            "totalWounds": self.totalWounds,
            "_lastCardDrawn": self._lastCardDrawn?.rawValue ?? "",
            "remaining": self.remaining.map { $0.rawValue },
            "discarded": self.discarded.map { $0.rawValue }
        ]
        return result
    }
    
    var lastCardDrawn: VolkareCard? {
        return self._lastCardDrawn
    }
    
    var cardsRemaining: Int {
        return remaining.count
    }
    
    func popNextCard() -> VolkareCard? {
        let card = remaining.popLast()
        if card != nil {
            discarded.append(card!)
            self.persist()
        }
        self._lastCardDrawn = card
        return card
    }
    
}
//
//  ReputationModel.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

class ReputationModel: PersistableModel {
    
    static var persistenceKey = "reputationModel"
    static private var startingPosition = 7
    private var _currentPosition = startingPosition { didSet { persist() } }
    
    // These are strings to accommodate the X, which
    // should be fine since we will never do math on these
    let reputationTrack: [String] = [
        "X",
        "-5",
        "-3",
        "-2",
        "-1",
        "-1",
        "0",
        "0",
        "0",
        "+1",
        "+1",
        "+2",
        "+2",
        "+3",
        "+5"
    ]
    
    required convenience init(fromJSONDict dict: [String : AnyObject]) {
        self.init()
        self._currentPosition = dict["_currentPosition"] as! Int
    }
    
    func dictForJSON() -> [String : AnyObject] {
        let result: [String: AnyObject]
        result = [
            "_currentPosition": self._currentPosition
        ]
        return result
    }
    
    var minimumRawValue: Int {
        return -1 * ReputationModel.startingPosition
    }
    
    var maximumRawValue: Int {
        return self.reputationTrack.count - ReputationModel.startingPosition - 1
    }
    
    var currentReputation: String {
        return reputationTrack[self._currentPosition]
    }
    
    var rawReputation: Int {
        return _currentPosition - ReputationModel.startingPosition
    }
    
    func incrementReputation() {
        self._currentPosition = min(self._currentPosition + 1, reputationTrack.count - 1)
    }
    
    func decrementReputation() {
        self._currentPosition = max(0, self._currentPosition - 1)
    }

}

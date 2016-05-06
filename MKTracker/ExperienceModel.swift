//
//  ExperienceModel.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

enum LevelUpReward: Int {
    case CommandToken, SkillAndAdvancedAction
}

class LevelUp: NSObject {
    var level: Int
    var threshold: Int
    var reward: LevelUpReward
    
    init(level: Int, threshold: Int, reward: LevelUpReward) {
        self.level = level
        self.threshold = threshold
        self.reward = reward
        super.init()
    }
    
    override var hashValue: Int {
        return self.level
    }
    
}

func ==(left: LevelUp, right: LevelUp) -> Bool {
    return left.level == right.level
}

class ExperienceModel: PersistableModel {
    
    static var persistenceKey = "experienceModel"
    private var _currentXP = 0 { didSet { persist() } }
    var earnedLevelUps = [LevelUp]() { didSet { persist() } }
    var processedLevelUps = [LevelUp: Bool]() { didSet { persist() } }
    
    // Some methods assume this is already sorted, so don't screw it up
    let levels: [LevelUp] = [
        LevelUp(level: 1, threshold: 0, reward: LevelUpReward.CommandToken),
        LevelUp(level: 2, threshold: 3, reward: LevelUpReward.SkillAndAdvancedAction),
        LevelUp(level: 3, threshold: 8, reward: LevelUpReward.CommandToken),
        LevelUp(level: 4, threshold: 15, reward: LevelUpReward.SkillAndAdvancedAction),
        LevelUp(level: 5, threshold: 24, reward: LevelUpReward.CommandToken),
        LevelUp(level: 6, threshold: 35, reward: LevelUpReward.SkillAndAdvancedAction),
        LevelUp(level: 7, threshold: 48, reward: LevelUpReward.CommandToken),
        LevelUp(level: 8, threshold: 63, reward: LevelUpReward.SkillAndAdvancedAction),
        LevelUp(level: 9, threshold: 80, reward: LevelUpReward.CommandToken),
        LevelUp(level: 10, threshold: 99, reward: LevelUpReward.SkillAndAdvancedAction)
    ]
    
    required convenience init(fromJSONDict dict: [String: AnyObject]) {
        self.init()
        self._currentXP = dict["_currentXP"] as! Int
        for levelNumber in dict["earnedLevelUps"] as! [Int] {
            earnedLevelUps.append(levels[levelNumber - 1])
        }
        for levelNumber in dict["processedLevelUps"] as! [Int] {
            processedLevelUps[levels[levelNumber - 1]] = true
        }
    }
    
    func dictForJSON() -> [String : AnyObject] {
        let result: [String: AnyObject]
        result = [
            "_currentXP": self._currentXP,
            "earnedLevelUps": self.earnedLevelUps.map { $0.level },
            "processedLevelUps": self.processedLevelUps.keys.map { $0.level }
        ]
        return result
    }
    
    // Returns bool of whether a level up occurred
    func incrementXP() -> Bool {
        let startLevel = self.currentLevel
        self._currentXP += 1
        if startLevel != self.currentLevel {
            if !self.earnedLevelUps.contains(self.currentLevel) {
                self.earnedLevelUps.append(self.currentLevel)
            }
            return true
        }
        return false
    }
    
    // Returns bool of whether a level up occurred
    func decrementXP() -> Bool {
        let startLevel = self.currentLevel
        self._currentXP -= 1
        if startLevel != self.currentLevel {
            self.earnedLevelUps.removeLast(1)
            return true
        }
        return false
    }
    
    func processNextLevelUp() {
        if let first = self.pendingLevelUps.first {
            self.processedLevelUps[first] = true
        }
    }
    
    // Returns list of level ups earned but not yet processed,
    // sorted by ascending level
    var pendingLevelUps: [LevelUp] {
        var result = [LevelUp]()
        for level in self.earnedLevelUps {
            if self.processedLevelUps[level] == nil {
                result.append(level)
            }
        }
        return result.sort({ (l1, l2) -> Bool in
            l1.level < l2.level
        })
    }
    
    var currentXP: Int {
        return self._currentXP
    }
    
    var currentLevel: LevelUp {
        for level in self.levels.reverse() {
            if self.currentXP >= level.threshold { return level }
        }
        return levels[0] // should never get here, just appeasing compiler
    }
    
    var nextLevel: LevelUp? {
        for level in levels {
            if level.threshold > self.currentXP { return level }
        }
        return nil
    }
    
    var distanceToNextLevel: Int? {
        if let nextThreshold = nextLevel?.threshold {
            return nextThreshold - self.currentXP
        }
        return nil
    }

}

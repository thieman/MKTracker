//
//  PersistableModel.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

protocol PersistableModel: class {
    static var persistenceKey: String { get }
    init(fromJSONDict: [String: AnyObject])
    func dictForJSON() -> [String: AnyObject]
}

extension PersistableModel {
    static func initFromUserDefaults() -> PersistableModel? {
        if let json = fetchJSONFromUserDefaults(self.persistenceKey) {
            return self.init(fromJSONDict: fromJSON(json)!)
        }
        return nil
    }
    
    func persist() {
        saveJSONToUserDefaults(self)
    }
}

func fromJSON(json: String) -> [String: AnyObject]? {
    do {
        return try NSJSONSerialization.JSONObjectWithData(json.dataUsingEncoding(NSUTF8StringEncoding)!, options: NSJSONReadingOptions(rawValue: 0)) as? [String: AnyObject]
    } catch _ {
        return nil
    }
}

func toJSON(model: PersistableModel) -> String? {
    do {
        let data = try NSJSONSerialization.dataWithJSONObject(model.dictForJSON(), options: NSJSONWritingOptions(rawValue: 0))
        return String.init(data: data, encoding: NSUTF8StringEncoding)
    } catch _ {
        return nil
    }
}

func fetchJSONFromUserDefaults(persistenceKey: String) -> String? {
    let defaults = NSUserDefaults.standardUserDefaults()
    return defaults.stringForKey(persistenceKey)
}

func saveJSONToUserDefaults(model: PersistableModel) {
    let defaults = NSUserDefaults.standardUserDefaults()
    let persistenceKey = (Mirror(reflecting: model).subjectType as! PersistableModel.Type).persistenceKey
    defaults.setObject(toJSON(model), forKey: persistenceKey)
}
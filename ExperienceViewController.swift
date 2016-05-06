//
//  ExperienceViewController.swift
//  MKTracker
//
//  Created by Travis Thieman on 5/6/16.
//  Copyright © 2016 Travis Thieman. All rights reserved.
//

import UIKit

class ExperienceViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: Init
    
    @IBOutlet weak var currentXPLabel: UILabel!
    @IBOutlet weak var distanceXPLabel: UILabel!
    @IBOutlet weak var currentLevelLabel: UILabel!
    @IBOutlet weak var levelTableView: UITableView!
    
    let model = ExperienceModel.initFromUserDefaults() as? ExperienceModel ?? ExperienceModel()
    var lastSenderValue = 0.0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        let icon = Utils.imageFromText("★", font: UIFont(name: "Helvetica", size: 32)!, maxWidth: CGFloat(64), color: UIColor.blueColor())
        tabBarItem = UITabBarItem(title: "XP", image: icon, tag: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .None
        self.levelTableView.dataSource = self
        self.levelTableView.delegate = self
        self.levelTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "ident")
        updateUI()
    }
    
    // MARK: Simple UI
    
    @IBAction func changeXP(sender: UIStepper) {
        if sender.value > lastSenderValue {
            model.incrementXP()
        } else {
            model.decrementXP()
        }
        lastSenderValue = sender.value
        updateUI()
    }
    
    func updateUI() {
        currentXPLabel.text = "\(model.currentXP)"
        if let distance = model.distanceToNextLevel {
            distanceXPLabel.text = "\(distance) to Next Level"
        } else {
            distanceXPLabel.text = "Max Level!"
        }
        currentLevelLabel.text = "Level \(model.currentLevel.level)"
        levelTableView.reloadData()
    }
    
    // MARK: TableView
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.pendingLevelUps.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let tvc = tableView.dequeueReusableCellWithIdentifier("ident") {
            let thisLevel = self.model.pendingLevelUps[indexPath.row]
            tvc.textLabel!.text = "Level \(thisLevel.level): "
            if thisLevel.reward == .CommandToken {
                tvc.textLabel!.text! += "Command Token"
            } else {
                tvc.textLabel!.text! += "Skill and Advanced Action"
            }
            return tvc
        }
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard indexPath.row == 0 else { // must level up in order
            return
        }
        self.model.processNextLevelUp()
        updateUI()
    }
    
}

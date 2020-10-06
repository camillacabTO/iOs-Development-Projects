//
//  GoalCell.swift
//  GoalPost_app
//
//  Created by Camila Barros on 2020-04-14.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressionLbl: UILabel!
    @IBOutlet weak var goalCompleteLbl: UIView!
    
    func configureCell(goal: Goal) {
        goalDescriptionLbl.text = goal.goalDescription
        goalTypeLbl.text = goal.goalType
        goalProgressionLbl.text = String(describing: goal.goalProgress)
        
        if goal.goalProgress == goal.goalCompletionValue {
            goalCompleteLbl.isHidden = false
        } else {
            goalCompleteLbl.isHidden = true
        }
    }
}

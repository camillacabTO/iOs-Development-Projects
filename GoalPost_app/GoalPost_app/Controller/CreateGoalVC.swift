//
//  CreateGoalVC.swift
//  GoalPost_app
//
//  Created by Camila Barros on 2020-04-15.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit

class CreateGoalVC: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextField: UITextView!
    @IBOutlet weak var nextBTN: UIButton!
    @IBOutlet weak var longTermBTN: UIButton!
    @IBOutlet weak var shortTermBTN: UIButton!
    
    var goalType: GoalType = .shorTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextBTN.bindToKeyboard()
        goalTextField.delegate = self
    }
    
    @IBAction func shortTermBTNPressed(_ sender: Any) {
        goalType = .shorTerm
        shortTermBTN.setSelectedColor()
        longTermBTN.setDeselectedColor()
    }
    
    @IBAction func longTermBTNPressed(_ sender: Any) {
        goalType = .longTerm
        longTermBTN.setSelectedColor()
        shortTermBTN.setDeselectedColor()
    }
    
    @IBAction func nextBTNPressed(_ sender: Any) {
        if goalTextField.text != "" && goalTextField.text != "What is your goal?" {
            guard let finishedGoalVC = storyboard?.instantiateViewController(identifier: "FinishedGoalVC") as? FinishedGoalVC else { return }
            finishedGoalVC.initGoalCreation(descriptin: goalTextField.text, type: goalType)
            self.present(finishedGoalVC,animated: true,completion: nil)
        }
    }
    
    @IBAction func backBTNPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        goalTextField.text = ""
    }
    
    
}

//
//  FinishedGoalVC.swift
//  GoalPost_app
//
//  Created by Camila Barros on 2020-04-21.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit
import CoreData

class FinishedGoalVC: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var createGoalBTN: UIButton!
    @IBOutlet weak var pointsTextField: UITextField!
    
    var goalDescription : String!
    var goalType : GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(goalDescription ?? "no goal") \(goalType!)")
    }
    
    func initGoalCreation(descriptin: String, type: GoalType) {
        self.goalDescription = descriptin
        self.goalType = type
    }
    
    @IBAction func pointsStepperChanged(_ sender: UIStepper) {
        let stepperValue = Int(sender.value)
        pointsTextField.text = "\(stepperValue)"
    }
    
    @IBAction func createGoalBTNPressed(_ sender: Any) {
        if Int(pointsTextField.text!)! > 0 {
            saveGoal { (complete) in
                if complete {
                    let goalsVC = self.storyboard?.instantiateViewController(withIdentifier: "GoalsVC") as! GoalsVC
                    let navigationController: UINavigationController = UINavigationController(rootViewController: goalsVC)
                    navigationController.modalPresentationStyle = .fullScreen
                    present(navigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func saveGoal(completion: (_ finished: Bool) -> Void) {
        let newGoal = Goal(context: context)
        newGoal.goalDescription = self.goalDescription
        newGoal.goalType = self.goalType.rawValue
        newGoal.goalCompletionValue = Int32(pointsTextField.text!)!
        newGoal.goalProgress = Int32(0)
        print("New goal saved")
        
        do {
            try context.save()
            completion(true)
        } catch {
            debugPrint("Could not save new goal \(error.localizedDescription)")
            completion(false)
        }
    }
    
}

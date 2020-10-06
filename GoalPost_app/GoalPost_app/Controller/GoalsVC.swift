//
//  GoalsVC.swift
//  GoalPost_app
//
//  Created by Camila Barros on 2020-04-14.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit
import CoreData

class GoalsVC: UIViewController {

    @IBOutlet weak var goalsTableView: UITableView!
    
    var goalsArr = [Goal]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addGoalsBTNPressed(_ sender: Any) {
        guard let creatGoalVC = storyboard?.instantiateViewController(withIdentifier:"CreateGoalVC") else { return }
        self.present(creatGoalVC, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear (_ animated: Bool) {
        super.viewWillAppear(true)
        print("View Appeared")
        fetchCoreDateObjs()
        print(goalsArr.count)
    }

    func fetchCoreDateObjs(){
        self.fetch { (complete) in
            if complete {
                if goalsArr.count < 1 {
                    goalsTableView.isHidden = true
                } else {
                    goalsTableView.isHidden = false
                }
            }
        }
    }
}

extension GoalsVC : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        goalsArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell") as? GoalCell
        let currentGoal = goalsArr[indexPath.row]
        cell?.configureCell(goal: currentGoal)
        return cell ?? UITableViewCell()
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//
//        if editingStyle == .delete {
//            print("Deleted")
//            self.context.delete(self.goalsArr[indexPath.row])
//            self.goalsArr.remove(at: indexPath.row)
//            do {
//                try self.context.save()
//                print("Successfully removed goal!")
//            } catch {
//                debugPrint("Could not remove \(error.localizedDescription)")
//            }
//            self.goalsTableView.deleteRows(at: [indexPath], with: .automatic)
//            print(goalsArr.count)
//            self.fetchCoreDateObjs()
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { _, _, complete in
            self.context.delete(self.goalsArr[indexPath.row])
            self.goalsArr.remove(at: indexPath.row)
            self.save()
            self.goalsTableView.deleteRows(at: [indexPath], with: .automatic)
            self.fetchCoreDateObjs()
            complete(true)
        }
        
        let updateAction = UIContextualAction(style: .normal, title: "ADD 1") { (_, _, complete) in
            self.updateProgress(atIndexPath: indexPath)
            self.goalsTableView.reloadRows(at: [indexPath], with: .automatic)
            complete(true)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        updateAction.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction, updateAction])
        return configuration
    }
}

extension GoalsVC {
    
    func fetch(completion: (_ complete: Bool) -> Void){
        
        let fetchRequest : NSFetchRequest<Goal> = Goal.fetchRequest()
        
        do {
            self.goalsArr = try context.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch \(error.localizedDescription)")
            completion(false)
        }
        goalsTableView.reloadData()
    }
    
    func delete(atIndex indexPath : IndexPath){
        context.delete(self.goalsArr[indexPath.row])
        
        do {
            try context.save()
            print("Successfully removed goal!")
        } catch {
            debugPrint("Could not remove \(error.localizedDescription)")
        }
    }
    
    func save() {
        do {
            try self.context.save()
            print("Successfully removed goal!")
        } catch {
            debugPrint("Could not remove \(error.localizedDescription)")
        }
    }
    
    func updateProgress(atIndexPath indexPath:IndexPath){
        let selectedGoal = goalsArr[indexPath.row]
        if selectedGoal.goalProgress < selectedGoal.goalCompletionValue {
            selectedGoal.goalProgress = selectedGoal.goalProgress + 1
        }
        save()
    }
}

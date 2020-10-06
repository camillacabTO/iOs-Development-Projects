//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Camila Barros on 2020-04-02.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categories = [Category]()
    
    // MARK: Add new Category
    
    @IBAction func addCategoryBTN(_ sender: Any) {
        var textAdded = UITextField()
        let alert = UIAlertController(title: "Add a new Category", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textAdded.text!
            self.categories.append(newCategory)
            self.saveCategory()
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a Category"
            textAdded = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCategories()
    }
    
    // MARK: - Table view data source / delegate

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                context.delete(categories[indexPath.row])
                categories.remove(at: indexPath.row)
                saveCategory()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let itemVC = segue.destination as! ViewController
        if let indexSelected = tableView.indexPathForSelectedRow {
            itemVC.selectedCategory = categories[indexSelected.row]
        }
    }

    // MARK: Data Manipulation Methods
    
    func fetchCategories(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error fetching the data categories \(error)")
        }
        tableView.reloadData()
    }
    
    func saveCategory(){
        do {
            try context.save()
        } catch let savingError {
            print("Error saving context categories \(savingError)")
        }
        self.tableView.reloadData()
    }

}

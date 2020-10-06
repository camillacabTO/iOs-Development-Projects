//
//  ViewController.swift
//  ToDo
//
//  Created by Camila Barros on 2020-03-29.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var itemsTableView: UITableView! {
        didSet {
            fetch() // Has to fetch only after the tableView is set. Because by the time the selectedCategory (first thing to happen) is set the tableView is still nill
        }
    }

    @IBOutlet weak var searchToDoBar: UISearchBar!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // UIApplication.shared is a singleton/static property representing the current the app. Delegate represents the AppDelegate. It is a way to access/grab the persistentContainer.viewContext property inside AppDelegate
    
    var itemsArray = [Item]()
    var selectedCategory : Category? // first thing to happens after the segue is perform
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.barTintColor = UIColor.green
    }
    
    @IBAction func addItemBTN(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add a new Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item(context: self.context)  // creating a new Item in the CoreData Model with its initializer
            newItem.title = textField.text!
            newItem.parentCategory = self.selectedCategory
            self.itemsArray.append(newItem)
            self.saveItems()   // saving changes after creating the new item
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create an Item"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "itemsCell")
        let item = itemsArray[indexPath.row]
        cell.textLabel!.text = item.value(forKey: "title") as? String  // grabind data from attribute
        cell.accessoryType = item.done ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemsArray[indexPath.row].done = !itemsArray[indexPath.row].done // Toggle checkmark by tapping on row
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(itemsArray[indexPath.row]) // deleting: first from the CoreData Model than from the TableView array
            itemsArray.remove(at: indexPath.row)
            saveItems() // Modifing the Core Data Model. Save to commit changes to the database
        }
    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("Error saving context \(error)")
        }
        itemsTableView.reloadData()
    }
    
    func fetch(with request : NSFetchRequest<Item> = Item.fetchRequest(), AndPredicate customPredicate : NSPredicate? = nil){
        
        let categoryPredicate : NSPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!) // default predicate
        
        if let validCustomPredicate = customPredicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate,validCustomPredicate]) // assign both precicates if the custom one is not nill
        } else {
            request.predicate = categoryPredicate // if not assign only the category predicate
        }
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        do {
            itemsArray = try context.fetch(request)  // Fetchin requires a request
        } catch {
            print("Error fetching the data \(error)")
        }
        itemsTableView.reloadData()
    }
}

extension ViewController : UISearchBarDelegate {
    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)  // Add predicate to request
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // Add sortDescriptors to request (expects an array)
//        fetch(with: request)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if !searchText.isEmpty {
            let predicate  = NSPredicate(format: "title CONTAINS[cd] %@", searchText) // goes in the fetch function
            fetch(AndPredicate: predicate)
        } else {
            fetch()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

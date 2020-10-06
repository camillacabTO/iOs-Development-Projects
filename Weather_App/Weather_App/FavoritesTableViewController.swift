//
//  FavoritesTableViewController.swift
//  Weather_App
//
//  Created by Camila Barros on 2020-04-06.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit
import CoreData

class FavoritesTableViewController: UITableViewController, UISearchBarDelegate {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var searchBarFavCity: UISearchBar!
    var favoriteCities = [City]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchFavCities()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavCityCell", for: indexPath)
        cell.textLabel?.text = favoriteCities[indexPath.row].name
        cell.detailTextLabel?.text = favoriteCities[indexPath.row].country
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            context.delete(favoriteCities[indexPath.row])
            favoriteCities.remove(at: indexPath.row)
            saveFavCities()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toWeatherDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toWeatherDetails") {
            let weatherDetailsVC = segue.destination as! WeatherDetailsViewController
            if let indexSelected = tableView.indexPathForSelectedRow {
                guard let city = favoriteCities[indexSelected.row].name else { return }
                weatherDetailsVC.cityName = city
            }
        }
    }
}

extension FavoritesTableViewController {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
          if !searchText.isEmpty {
              let searchBarPredicate : NSPredicate = NSPredicate(format: "name CONTAINS[cd] %@", searchText)
              fetchFavCities(with: searchBarPredicate)
          } else {
              fetchFavCities()
              DispatchQueue.main.async {
                  searchBar.resignFirstResponder()
              }
          }
      }
    
    func fetchFavCities(with predicate : NSPredicate? = nil) {
        let request : NSFetchRequest<City> = City.fetchRequest()
        
        if predicate != nil {
            request.predicate = predicate
        }
        do {
            favoriteCities = try context.fetch(request)
        } catch {
            print("Error fetching the data \(error)")
        }
        tableView.reloadData()
    }
    
    func saveFavCities(){
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
        tableView.reloadData()
    }
    
}

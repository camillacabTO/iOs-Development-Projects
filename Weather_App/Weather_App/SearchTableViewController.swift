//
//  SearchTableViewController.swift
//  Weather_App
//
//  Created by Camila Barros on 2020-03-30.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit
import CoreData

class SearchTableViewController: UITableViewController, CitiesProtocol, UISearchBarDelegate {
    
    var Cities = [String]()
    var fetching = FetchRequest()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func didFinishedfetchingInfo(citiesArr: [String]) {
        DispatchQueue.main.async {
            self.Cities = citiesArr
            self.tableView.reloadData()
        }
    }
    
    func didFailedWithError(error: Error) {
        print("Error fetching data \(error)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetching.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Cities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitySearchCell", for: indexPath)
        let fullCityName = Cities[indexPath.row]
        let index = fullCityName.firstIndex(of: ",") ?? fullCityName.endIndex
        cell.textLabel?.text = String(fullCityName[..<index]) // Getting city name only from retrived String
        let lastIndexOfComma = fullCityName.lastIndex(of: ",") ?? fullCityName.startIndex
        let range = fullCityName.index(lastIndexOfComma, offsetBy: +2)..<fullCityName.endIndex
        cell.detailTextLabel?.text = String(fullCityName[range]) // Getting country name only from API String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = Cities[indexPath.row];
        let index = selectedCity.firstIndex(of: ",") ?? selectedCity.endIndex
        let range = selectedCity.index(selectedCity.lastIndex(of: ",")!, offsetBy: +2)..<selectedCity.endIndex
        let newFavCity = City(context: context)
        newFavCity.name = String(selectedCity[..<index])
        newFavCity.country = String(selectedCity[range])
        saveFavCities()
        Alert.showBasicAlert(on: self, title: "Saved", message: "This city was saved to your favorites")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchThis = searchBar.text {
            fetching.feachCity(cityName: searchThis)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if(searchBar.text?.count == 0){
            Cities = []
            DispatchQueue.main.async {
                self.tableView.reloadData()
                searchBar.resignFirstResponder()
            }
        }
    }
}

extension SearchTableViewController {
    
    func saveFavCities(){
        do {
            try context.save()
        } catch  {
            print("Error saving context \(error)")
        }
    }
}


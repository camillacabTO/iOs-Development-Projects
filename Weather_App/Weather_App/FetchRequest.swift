//
//  FetchRequest.swift
//  Weather_App
//
//  Created by Camila Barros on 2020-03-30.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import Foundation

protocol CitiesProtocol {
    func didFinishedfetchingInfo(citiesArr: [String])
    func didFailedWithError(error: Error)
}

struct FetchRequest {
    
    var delegate : CitiesProtocol?

    let urlIni = "https://secure.geobytes.com/AutoCompleteCity?key=7c756203dbb38590a66e01a5a3e1ad96&q="
    
    func feachCity(cityName: String) {
        let fixedCity = cityName.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(urlIni)\(fixedCity)"
        performRequest(fullUrlString: urlString)
 }
    
    func performRequest (fullUrlString: String) {
     if let url = URL(string: fullUrlString) {
         let session = URLSession(configuration: .default)
         let task = session.dataTask(with: url) { (data, response, error) in
             if error != nil {
                 print(error!)
                 return
             }
             if let safeData = data {
                 self.parseJSON(CitiesArray: safeData)
                }
            }
            task.resume()
        }
    }
    
    func parseJSON (CitiesArray: Data){
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode([String].self, from: CitiesArray)
            self.delegate?.didFinishedfetchingInfo(citiesArr: decodedData)
        } catch let JSONError {
            self.delegate?.didFailedWithError(error: JSONError)
        }
    }

}


//
//  Currency.swift
//  BitCoin_App
//
//  Created by Camila Barros on 2020-03-16.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import Foundation

struct Currency : Codable {
    let currency : String
    let country : String
}

struct CurrencyList {
//    let urlStr = "https://api.coindesk.com/v1/bpi/supported-currencies.json"
    
    func performRequest(urlPar: String, completion: @escaping (Result<[Currency], Error>) -> ()) {
        guard let url = URL(string: urlPar) else {return}
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(error!))
                return
            }
            if let res = response as? HTTPURLResponse {
                print(res.statusCode)
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode([Currency].self, from: data)
//                    print(decodedData[0].country)
                    completion(.success(decodedData))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }
        task.resume()
    }
    
    
    
}

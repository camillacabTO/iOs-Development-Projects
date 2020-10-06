//
//  BitCoinPriceManager.swift
//  BitCoin_App
//
//  Created by Camila Barros on 2020-03-16.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

protocol CurrencyItemProtocol {
    func didFinishedfetchingInfo(CurrItem : CurrencyItem)
    func didFailedWithError(error: Error)
}

import Foundation

struct BitCoinPrice : Codable {
    let bpi : [String : CurrencyItem]
}

struct CurrencyItem : Codable {
    let code : String
    let rate_float : Double
}



struct BitCoinPriceManager {
    
    var delegate : CurrencyItemProtocol?
    
    func fetchBitPrice (currency : Currency) {
        let urlStr = "https://api.coindesk.com/v1/bpi/currentprice/\(currency.currency).json"
        guard let url = URL(string: urlStr) else {return}
        let session = URLSession(configuration: .default)
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                self.delegate?.didFailedWithError(error: error!)
            }
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(BitCoinPrice.self, from: data)
                    let rate = decodedData.bpi[currency.currency]?.rate_float
                    let code = decodedData.bpi[currency.currency]?.code
                    let currInfo = CurrencyItem(code: code!, rate_float: rate!)
                    self.delegate?.didFinishedfetchingInfo(CurrItem: currInfo)
                    
                } catch let jsonError {
                    self.delegate?.didFailedWithError(error: jsonError)
                }
            }
        }
        task.resume()
    }
    
    
}

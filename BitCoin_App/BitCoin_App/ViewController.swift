//
//  ViewController.swift
//  BitCoin_App
//
//  Created by Camila Barros on 2020-03-16.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CurrencyItemProtocol, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var diplayInfoLbl: UILabel!
    
    @IBOutlet weak var bitCoinImage: UIImageView!
    @IBOutlet weak var listCurrPickerView: UIPickerView!
    
    var currencies = [Currency]()
    var manager = BitCoinPriceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.bitCoinImage.image = UIImage(named: "bitcoin")
        listCurrPickerView.delegate = self
        listCurrPickerView.dataSource = self
        manager.delegate = self
        
        let currList = CurrencyList()
        currList.performRequest(urlPar: "https://api.coindesk.com/v1/bpi/supported-currencies.json") { (res) in
            switch res {
            case .success(let currs):
                self.currencies = currs
                DispatchQueue.main.async { self.listCurrPickerView.reloadAllComponents() }
            case .failure(let err):
                Alert.showBasicAlert(on: self, with: "Error", message: "No Internet Connection")
                print(err)
            }
        }
    }
    
    func didFailedWithError(error: Error) {
        print(error)
    }
    
    func didFinishedfetchingInfo(CurrItem: CurrencyItem) {
        DispatchQueue.main.async {
            self.diplayInfoLbl.text = String(format: "$%.2f",CurrItem.rate_float)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(currencies[row].currency) \(currencies[row].country)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        manager.fetchBitPrice(currency: currencies[row])
    }
    
}


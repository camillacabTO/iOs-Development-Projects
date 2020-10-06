//
//  WeatherDetailsViewController.swift
//  Weather_App
//
//  Created by Camila Barros on 2020-04-09.
//  Copyright © 2020 Camila Barros. All rights reserved.
//

import UIKit

class WeatherDetailsViewController: UIViewController{
    
    var weatherManager = WeatherManager()
    var weatherObj : WeatherData?
    
    @IBOutlet weak var CityNameLbl: UILabel!
    @IBOutlet weak var TempLbl: UILabel!
    @IBOutlet weak var DescriptionLbl: UILabel!
    
    var cityName : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let unwrappedCity = cityName?.replacingOccurrences(of: " ", with: "%20") else { return }

        weatherManager.performRequest(with: unwrappedCity) { (res) in
            switch res {
                case .success(let weatherInfo):
                    self.weatherObj = weatherInfo
                    DispatchQueue.main.async {
                        self.CityNameLbl.text = self.weatherObj?.name
                        self.DescriptionLbl.text = self.weatherObj?.weather[0].description
                        let formattedTemp = String.init(format: "Temperature: %.f degrees celcius",self.weatherObj!.main.temp)
                        self.TempLbl.text = formattedTemp
                   }
                case .failure(let err):
                    print(err)
            }
        }
    }
}


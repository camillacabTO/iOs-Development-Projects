//
//import Foundation
//
////protocol WeatherInfoProtocol {
////    func didFinishedfetchingInfo(WeatherInfo: WeatherData)
////    func didFailedWithError(error: Error)
////}
//
//struct WeatherManager {
//
////    var delegate : WeatherInfoProtocol?
//
////    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1d9f9c50c9d90b394b1b385160f2b044&units=metric"
////
////    func fetchWeather(with cityName: String) {
////        let urlString = "\(weatherURL)&q=\(cityName)"
////        performRequest(fullUrlString: urlString)
////    }
//
////    func performRequest (fullUrlString: String) {
////
////
////        if let url = URL(string: fullUrlString) {
//    func performRequest(urlPar: String, completion: @escaping (Result<[Currency], Error>) -> ()) {
//        guard let url = URL(string: urlPar) else {return}
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil { // manager error
//                    print(error!)
//                        return
//                    }
//                    if let safeData = data {
//                        self.parseJSON(weatherData: safeData)
//                    }
//                }
//                task.resume()
////        }
////    }
//
//    func parseJSON (weatherData: Data){
//        let decoder = JSONDecoder()
//        do {
//            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
////            self.delegate?.didFinishedfetchingInfo(WeatherInfo: decodedData)
////            print("City name: \(decodedData.name)")
////            let formattedTemp = String.init(format: "Temperature is: %.f degrees celcius", decodedData.main.temp)
////            print(formattedTemp)
////            print("Weather Description: \(decodedData.weather[0].description)")
//        } catch let jsonError{
////            self.delegate?.didFailedWithError(error: jsonError)
//        }
//    }
//}
//

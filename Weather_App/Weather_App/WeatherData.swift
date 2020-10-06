
import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}

struct Main : Codable {
    let temp : Double
}

struct Weather : Codable {
    let description : String
}

struct WeatherManager {
    
    func performRequest(with cityName: String, completion: @escaping (Result<WeatherData, Error>) -> ()) {
        
        let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=1d9f9c50c9d90b394b1b385160f2b044&units=metric&q=\(cityName)"
        guard let url = URL(string: weatherURL) else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                completion(.failure(error!))
                return
            }
            if let res = response as? HTTPURLResponse {
                print(res.statusCode)
            }
            if let safeData = data {
                let decoder = JSONDecoder()
                do {
                    let decodedData = try decoder.decode(WeatherData.self, from: safeData)
                    completion(.success(decodedData))
                } catch let jsonError {
                    completion(.failure(jsonError))
                }
            }
        }
        task.resume()
    }
}

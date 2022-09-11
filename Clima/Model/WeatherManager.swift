
import Foundation
import CoreLocation

struct WeatherManager{
    let url = "https://api.openweathermap.org/data/2.5/weather?appid=eef3477c682f46de328f1e5fefae476d&units=metric"
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(city: String){
        let url = "\(url)&q=\(city)"
        let newURL=removeSpace(url: url)
        performRequest(urlString: newURL)
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        let url = "\(url)&lat=\(latitude)&lon=\(longitude)"
        let newURL=removeSpace(url: url)
        performRequest(urlString: newURL)
    }
    
    func performRequest(urlString: String){
        //1
        if let url = URL(string: urlString){
            //2
            let session = URLSession(configuration: .default)
            //3
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                }
                
                if let safeData=data{
                    if let weather = parseJSON(weatherData: safeData){
                        delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            //4
            task.resume()
        }
        
    }
    
    
    func parseJSON(weatherData: Data)->WeatherModel?{
        
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp=decodedData.main.temp
            let name=decodedData.name
            let weather=WeatherModel(cityName: name, conditionID: id, temperature: temp)
//            print(weather.cityName)
//            print(weather.conditionName)
//            print(weather.temperature)
//            print(weather.temperatureString)
            return weather
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    func removeSpace(url: String)->String{
        return url.replacingOccurrences(of: " ", with: "%20")
    }
    
}

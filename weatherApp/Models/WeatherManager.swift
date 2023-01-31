//
//  WeatherManager.swift
//  weatherApp
//
//  Created by Pavel Mednikov on 28/12/2022.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate{
    func didUpdateWeather( weatherManager: WeatherManager, weatherModel: WeatherModel)
}


struct WeatherManager {
     
    var delegate: WeatherManagerDelegate?
    

    func featchWeather(cityName: String){
        
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=\(API)&units=metric"
        performRequest(urlString: urlString)
        
        
    }
    
    func featchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees){
        let urlString = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(API)&units=metric"
        
        performRequest(urlString: urlString)
    }
    
    
    func performRequest(urlString: String){
        if let url = URL(string: urlString){
            let urlSession = URLSession(configuration: .default)
            let task = urlSession.dataTask(with: url) { data, response, error in
                if  error != nil {
                    print(error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parceJSON(weatherdata: safeData){
                        delegate?.didUpdateWeather(weatherManager: self, weatherModel: weather)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    
    func parceJSON(weatherdata: Data) -> WeatherModel?{
        let decoder = JSONDecoder()
        do{
            let data = try decoder.decode(WeatherData.self, from: weatherdata)
            let cityName = data.name
            let temperature = data.main.temp
            let imageCondition = data.weather[0].id
            
            let weather = WeatherModel(cityName: cityName, temperature: temperature, conditionID: Int(imageCondition))
            self.delegate?.didUpdateWeather(weatherManager: self, weatherModel: weather)
            return weather
            
        }catch{
            
            return nil
            
        }
    }
}

//
//  WeatherData.swift
//  weatherApp
//
//  Created by Pavel Mednikov on 28/12/2022.
//

import Foundation
struct WeatherData: Decodable{
    
    let name: String
    let main: Main
    let weather: [Weather]
}


struct Main: Decodable{
    
    let temp: Double
}


struct Weather: Decodable{
    
    let id: Double
}



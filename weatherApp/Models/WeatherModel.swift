//
//  WeatherModel.swift
//  weatherApp
//
//  Created by Pavel Mednikov on 28/12/2022.
//

import Foundation

struct WeatherModel{
    let cityName: String
    let temperature: Double
    let conditionID: Int
    
    
    
    var conditionName: String{
        switch conditionID{
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.sun.rain"
        case 511:
            return "cloud.sleet"
        case 520...531:
            return "cloud.heavyrain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803...804:
            return "smoke"
        default:
            return "cloud"
            
        }
    }
}






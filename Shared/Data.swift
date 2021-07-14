//
//  Data.swift
//  weather-app
//
//  Created by Zari McFadden on 6/1/21.
//

import Foundation
import SwiftUI

struct Weather: Codable {
    var location: Location
    var current: Current
    var forecast: Forecast
}

struct Location: Codable {
    var name: String
    var region: String
}

struct Current: Codable {
    var tempC: Float
    var tempF: Float
    var condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case tempC = "temp_c"
        case tempF = "temp_f"
        case condition
    }
}

struct Condition: Codable {
    var text: String
    var icon: String
    var code: Int
}

struct Forecast: Codable {
    var forecastday: [ForecastDay]
}

struct ForecastDay: Codable {
    var date: String
    var day: Day
    var hour: [Hour]
}

struct Day: Codable {
    var maxTempC: Float
    var maxTempF: Float
    var minTempC: Float
    var minTempF: Float
    var avgTempC: Float
    var avgTempF: Float
    var dailyWillItRain: Int
    var dailyChanceOfRain: String
    var condition: Condition
    
    enum CodingKeys: String, CodingKey {
        case maxTempC = "maxtemp_c"
        case maxTempF = "maxtemp_f"
        case minTempC = "mintemp_c"
        case minTempF = "mintemp_f"
        case avgTempC = "avgtemp_c"
        case avgTempF = "avgtemp_f"
        case dailyWillItRain = "daily_will_it_rain"
        case dailyChanceOfRain = "daily_chance_of_rain"
        case condition
    }
}

struct Hour: Codable {
    var time: String
    var tempF: Float
    var tempC: Float
    var willItRain: Int
    
    enum CodingKeys: String, CodingKey {
        case tempF = "temp_f"
        case tempC = "temp_c"
        case willItRain = "will_it_rain"
        case time
    }
}

class Api {
    func getWeather(location: String, currentLocation: LocationViewModel, completion: @escaping (Weather) -> ()) {
        let apiKey = "c582aec00d66490f8aa162718210106"
        let l = (currentLocation.userLatitude == 0 && currentLocation.userLongitude == 0 ? "London" : "\(currentLocation.userLatitude)%20\(currentLocation.userLongitude)")
        let location: String = (location != "" ? location : l)
        let days: Int = 1
        if let url = URL(string: "https://api.weatherapi.com/v1/forecast.json?key=\(apiKey)&q=\(location)&days=\(days)&aqi=no&alerts=no") {
            URLSession.shared.dataTask(with: url) {(data, _, _) in

                if let data = data {
                    do {
                        let weather = try JSONDecoder().decode(Weather.self, from: data)
                        
                        DispatchQueue.main.async {
                            completion(weather)
                        }
                        
                    } catch { return }
                    
                } else { return }
            }.resume()
            
        } else { return }
    }
}


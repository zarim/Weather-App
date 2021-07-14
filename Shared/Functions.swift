//
//  functions.swift
//  weather-app
//
//  Created by Zari McFadden on 6/4/21.
//

import Foundation

func getWeekday(day: Int) -> String {
    var weekday = ""
    
    switch day {
        case 1:
            weekday = "Sunday"
        case 2:
            weekday = "Monday"
        case 3:
            weekday = "Tuesday"
        case 4:
            weekday = "Wednesday"
        case 5:
            weekday = "Thursday"
        case 6:
            weekday = "Friday"
        case 7:
            weekday = "Saturday"
        default:
            weekday = "Weekday"
    }
    
    return weekday
}

func getHourly(weather: Weather, degreeF: Bool) -> [[String]] {
    var hourly: [[String]] = []
    
    if degreeF {
        for i in weather.forecast.forecastday[0].hour {
            hourly.append([i.time, String(i.tempF), String(i.willItRain)])
        }
    } else {
        for i in weather.forecast.forecastday[0].hour {
            hourly.append([i.time, String(i.tempC), String(i.willItRain)])
        }
    }
    
    return hourly
}

func formatDate(date: String) -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    
    let d = dateFormatter.date(from: date)
    dateFormatter.dateFormat = "h:mm a"
    let stringD = dateFormatter.string(from: d!)
    
    return stringD
    
}

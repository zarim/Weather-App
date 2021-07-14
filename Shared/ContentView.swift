//
//  ContentView.swift
//  Shared
//
//  Created by Zari McFadden on 6/1/21.
//

import SwiftUI

struct ContentView: View {
    @State var weather = Weather(location: Location(name: "", region: ""), current: Current(tempC: 0, tempF: 0, condition: Condition(text: "", icon: "", code: 0)), forecast: Forecast(forecastday: [ForecastDay(date: "", day: Day(maxTempC: 0, maxTempF: 0, minTempC: 0, minTempF: 0, avgTempC: 0, avgTempF: 0, dailyWillItRain: 0, dailyChanceOfRain: "0", condition: Condition(text: "", icon: "", code: 0)), hour: [Hour(time: "2021-06-02 00:00", tempF: 0, tempC: 0, willItRain: 0)])]))
    @State var search: String = ""
    @State var showText: Bool = false
    @State var degreeF: Bool = true
    var locationViewModel = LocationViewModel()
    
    var body: some View {
        let hourly = getHourly(weather: weather, degreeF: degreeF)
        let date = Date()
        let calendar = Calendar.current
        let day = calendar.component(.weekday, from: date)
        let weekday = getWeekday(day: day)
        let hour = calendar.component(.hour, from: date)
        
        ZStack {
    
            if hour > 6 && hour < 11 {
                Image("sunrise")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
            }
            else if hour > 11 && hour < 17 {
                Image("day")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            else if hour > 17 && hour < 24 {
                Image("late afternoon")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            else {
                Image("evening")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .ignoresSafeArea()
            }
            
            VStack {
                Spacer()
                
                if showText {
                    TextField("Enter a location (city, zip code, or lat/long)", text: $search,
                              onCommit: {
                                Api().getWeather(location: search, currentLocation: locationViewModel){
                                    (weather) in self.weather = weather
                                }
                                showText = false
                              })
                        .foregroundColor(Color.black)
                        .background(Color.white)
                        .font(.body)
                        .border(Color.white)
                        .frame(width: 300, alignment: .center)
                        .padding(.bottom, 50)
                }
                
                Button(action: {
                    showText = (showText ? false : true)
                    
                }, label: {
                    Text(weather.location.name)
                        .font(.largeTitle)
                        .fontWeight(.light)
                        .foregroundColor(Color.white)
                        .padding(.bottom, 10.0)
                        .frame(width: 300)
                        .multilineTextAlignment(.center)
                })
                
                Text(weekday)
                    .font(.headline)
                    .fontWeight(.thin)
                    .foregroundColor(Color.white)
                    .padding(.bottom, 10.0)
                
                if degreeF {
                    Button(action: {degreeF = false},
                           label: {
                            Text(String(weather.current.tempF) + "°F")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 10.0)
                           })
                } else {
                    Button(action: {degreeF = true},
                           label: {
                            Text(String(weather.current.tempC) + "°C")
                            .font(.title)
                            .fontWeight(.light)
                            .foregroundColor(Color.white)
                            .padding(.bottom, 10.0)
                           })
                }
                
                Text(weather.current.condition.text)
                    .font(.title3)
                    .fontWeight(.thin)
                    .foregroundColor(Color.white)
                    .multilineTextAlignment(.center)
                    .frame(width: 350)
                
                Spacer()
                
                Text("Hourly Forecast")
                    .foregroundColor(Color.white)
                    .padding(.bottom)
                ScrollView(.horizontal) {
                    HStack(spacing: 10) {
                        ForEach (hourly, id: \.self) {hour in
                            let time = formatDate(date: hour[0].components(separatedBy: " ")[1])
                            let temp = hour[1]
                            let rain = Int(hour[2])
                            

                            Spacer()
                            VStack {
                                Text(time).font(.headline).fontWeight(.light).foregroundColor(Color.white).padding(.bottom)
                                Text(degreeF ? temp + "°F" : temp + "°C").font(.title3).fontWeight(.regular).foregroundColor(Color.white).padding(.bottom)
                                Text((rain == 0 ? "No Rain" : "Rain")).font(.headline).fontWeight(.light).foregroundColor(Color.white).padding(.bottom)
                            }
                            Spacer()
                        }
                    }
                    .padding(.leading, 5.0)
                }.frame(width: 300)
                
                Spacer()
            }
            
        }.onAppear(perform: {
            Api().getWeather(location: search, currentLocation: locationViewModel){(weather) in self.weather = weather}
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

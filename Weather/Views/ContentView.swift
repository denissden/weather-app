//
//  ContentView.swift
//  Weather
//
//  Created by deniss on 4/14/23.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    @EnvironmentObject() var dependencies: Dependencies
    @State var location: CLLocation?
    @State var locationForecast: Forecast?
    @State var forecastDays: Int = 10
    
    let forecastDaysOptions = [10, 7, 3]
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(gradient: Gradient(colors: [Color("AppBackground_1"), Color("AppBackground_2")]),
                               startPoint: .topLeading,
                               endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
                ScrollView {
                    VStack {
                        
                        Text(locationForecast?.location.name ?? "--")
                            .font(.system (size: 32, weight: .medium))
                            .foregroundColor(Color("AppText"))
                            .padding()
                        
                        if let now = locationForecast?.now {
                            WeatherIcon(forecastInfo: now)
                                .frame(width: 180, height: 180)
                        }
                        
                        if let temp = locationForecast?.now.tempC {
                            Text(String(format: "%2.1f", temp) + "°")
                                .font(.system (size: 48, weight: .medium))
                                .foregroundColor(Color("AppText"))
                        } else {
                            Text("--")
                                .font(.system (size: 48, weight: .medium))
                                .foregroundColor(Color("AppText"))
                                .padding()
                        }
                        if let condition = locationForecast?.now.conditionName {
                            Text(condition)
                                .font(.system (size: 18, weight: .medium))
                                .foregroundColor(Color("AppText"))
                        }
                    }
                    if let days = locationForecast?.days {
                        DaysView(days: days, forecastDays: forecastDays, forecastDaysOptions: forecastDaysOptions)
                    }
                    Spacer()
                }
            }
        }
        .onAppear() {
            dependencies.locationProvider.setup() { location in
                if self.location != nil { return }
                
                self.location = location
                requestWeather()
            }
        }
    }
    
    private func requestWeather() {
        self.dependencies.weatherService.request()
            .provideLocation(dependencies.locationProvider)
            .days(forecastDaysOptions.max()!)
            .execute() { forecast, error in
                print(error)
                guard forecast != nil else { return }
                self.locationForecast = forecast
            }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().preferredColorScheme(.light)
            .environmentObject(Dependencies.preview)
        ContentView().preferredColorScheme(.dark)
            .environmentObject(Dependencies.preview)
    }
}

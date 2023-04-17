//
//  WeatherIcon.swift
//  Weather
//
//  Created by deniss on 4/17/23.
//

import SwiftUI

struct WeatherIcon: View {
    @State var forecastInfo: ForecastIconInfo?
    
    var body: some View {
        Image(systemName: getWeatherIcon(forecastInfo))
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
    
    private func getWeatherIcon(_ forecast: ForecastIconInfo?) -> String {
        
        guard let f = forecast else { return "dot.radiowaves.right" }

        switch (f.isDay, f.isRain, f.isSnow, f.cloudCoverage) {
            case (true, _, _, 0...30): return "sun.max.fill"
            case (false, _, _, 0...30): return "moon.fill"
            case (true, false, false, 31...70): return "cloud.sun.fill"
            case (false, false, false, 31...70): return "cloud.moon.fill"
            case (_, false, false, 71...100): return "cloud.fill"
            
            case (true, true, false, 31...70): return "cloud.sun.rain.fill"
            case (_, true, false, 71...100): return "cloud.rain.fill"
            case (false, true, false, 31...70): return "cloud.moon.rain.fill"
                
            case (_, false, true, 31...100): return "cloud.snow.fill"
                
            case (_, _, _, _):
                return "chart.dots.scatter"
        }
    }
}

protocol ForecastIconInfo {
    var isDay: Bool { get }
    var isRain: Bool { get }
    var isSnow: Bool { get }
    var cloudCoverage: Int { get }
}

extension SingleForecast : ForecastIconInfo { }


extension DayForecast : ForecastIconInfo {
    var isDay: Bool {
        true
    }
    
    var cloudCoverage: Int {
        hours.first?.cloudCoverage ?? 0
    }
}

struct WeatherIcon_Previews: PreviewProvider {
    static var previews: some View {
        WeatherIcon()
    }
}

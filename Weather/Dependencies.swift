//
//  Dependencies.swift
//  Weather
//
//  Created by deniss on 4/15/23.
//

import Foundation


class Dependencies: ObservableObject {
    let timeProvider: any TimeProvider
    let locationProvider: any LocationProvider
    let weatherService: any WeatherService
    
    init(
        timeProvider: any TimeProvider,
        locationProvider: any LocationProvider,
        weatherService: any WeatherService
    ) {
        self.timeProvider = timeProvider
        self.locationProvider = locationProvider
        self.weatherService = weatherService
    }
}

extension Dependencies {
    static var main: Dependencies {
        return Dependencies(
            timeProvider: DeviceTimeProvider(),
            locationProvider: DeviceLocationProvider(),
            weatherService: ApiWeatherService()
        )
    }
}

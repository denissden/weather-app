//
//  PreviewServices.swift
//  Weather
//
//  Created by deniss on 4/17/23.
//

import Foundation
import CoreLocation


extension Dependencies {
    static var preview: Dependencies {
        return Dependencies(
            timeProvider: DeviceTimeProvider(),
            locationProvider: PreviewLocationProvider(
                location: CLLocation(
                    latitude: CLLocationDegrees(37),
                    longitude: CLLocationDegrees(-122))
            ),
            weatherService: PreviewWeatherService()
        )
    }
}

class PreviewLocationProvider : LocationProvider {
    private var onUpdate: ((CLLocation) -> Void)?
    private var location: CLLocation
    
    init(location: CLLocation) {
        self.location = location
    }
    
    func setup(onUpdate: @escaping (CLLocation) -> Void) {
        onUpdate(location)
    }
    
    func getLocation() -> CLLocation? {
        return location
    }
}


class PreviewWeatherService : WeatherService {
    
    func execute(request: WeatherRequest, completionHandler: @escaping (Forecast?, Bool) -> Void) {
        completionHandler(getForecast(request: request), false)
    }
    
    private func getForecast(request: WeatherRequest) -> Forecast {
        let singleForecast = SingleForecast(
            timeStamp: -1,
            date: Date(),
            tempC: 42,
            tempF: 42.1,
            conditionName: "Sunny",
            isDay: false,
            isRain: false,
            isSnow: true,
            cloudCoverage:30,
            chanceOfRain: 30,
            chanceOfSnow: 0)
        let dayForecast = DayForecast(
            date: Date(),
            maxtempC: 42,
            maxtempF: 42.1,
            mintempC: 42,
            mintempF: 42.1,
            isRain: false,
            isSnow: false,
            chanceOfRain: 30,
            chanceOfSnow: 0,
            hours: [SingleForecast](repeating: singleForecast, count: 24))

        return Forecast(
            location: Location(name: "San Francisco", region: "CA", country: "US", localtime: Date()),
            now: singleForecast,
            days: [DayForecast](repeating: dayForecast, count: request.daysNumber ?? 10))
    }
}

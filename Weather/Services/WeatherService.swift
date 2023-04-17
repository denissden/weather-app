//
//  WeatherService.swift
//  Weather
//
//  Created by deniss on 4/15/23.
//

import Foundation
import Alamofire


protocol WeatherService {
    func execute(request: WeatherRequest, completionHandler: @escaping (Forecast?, Bool) -> Void)
}

class ApiWeatherService: WeatherService {
    
    private var apiKey: String
    private var baseUrl: URL
    private var forecastURL: URL
    
    init () {
        if let key = getPlistKey("WEATHER_API_KEY") {
            apiKey = key
        } else {
            fatalError("Weather API key missing (please specify it in xcconfig)")
        }
        
        // Enable http loading
        // Project -> Info -> App Transport Security Settings -> Allow Arbitrary Loads = YES
        if let url = URL(string: getPlistKey("WEATHER_API_URL")!) {
            baseUrl = url
        } else {
            fatalError("Weather API Url was invalid (please specify it in xcconfig)")
        }
        
        forecastURL = URL(string: "v1/forecast.json", relativeTo: baseUrl)!
    }
    
    func execute(request: WeatherRequest, completionHandler: @escaping (Forecast?, Bool) -> Void) {
        let params = getParams(request: request)
        
        AF.request(forecastURL, parameters: params)
            .response { res in
                print(self.baseUrl.absoluteString)
                print(self.forecastURL.absoluteString)
                print(res)
            }
            .responseDecodable(of: WeatherApiResponseDto.self) { (AFresponse) in
                guard let response = AFresponse.value else {
                    print(String(describing: AFresponse.error?.localizedDescription))
                    return completionHandler(nil, true)
                }
                completionHandler(response.toForecastModel(), false)
            }
    }
    
    private func getParams(request: WeatherRequest) -> [String: String] {
        var params = [String: String]()
        if let location = request.locationProvider?.getLocation() {
            params["q"] = "\(location.coordinate.latitude),\(location.coordinate.longitude)"
        } else {
            params["q"] = request.cityName
        }
        
        if let days = request.daysNumber {
            params["days"] = "\(days)"
        }
        
        params["key"] = apiKey
        
        return params
    }
}

enum WeatherRequestType {
    case forecast, current
}

class WeatherRequest {
    let weatherService: WeatherService
    var requestType: WeatherRequestType?
    var daysNumber: Int?
    var cityName: String?
    var locationProvider: LocationProvider?
    
    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }
    
    func days(_ daysNumber: Int) -> Self {
        self.daysNumber = daysNumber
        return self
    }
    
    func city(_ cityName: String) -> Self {
        self.cityName = cityName
        return self
    }
    
    func provideLocation(_ provider: LocationProvider) -> Self {
        self.locationProvider = provider
        return self
    }
    
    func execute(completionHandler: @escaping (Forecast?, Bool) -> Void) {
        self.weatherService.execute(request: self, completionHandler: completionHandler)
    }
}

extension WeatherService {
    func request() -> WeatherRequest {
        return WeatherRequest(weatherService: self)
    }
}

extension WeatherApiResponseDto {
    func toForecastModel() -> Forecast {
        return Forecast(
            location: location.toLocationModel(),
            now: current.toSingleForecast(),
            days: forecast.forecastday.map() { $0.toDayForecast() }
        )
    }
}

extension LocationDto {
    func toLocationModel() -> Location {
        return Location(
            name: name,
            region: region,
            country: country,
            localtime: Date(timeIntervalSince1970: TimeInterval(localtimeEpoch)))
    }
}

extension CurrentDto {
    func toSingleForecast() -> SingleForecast {
        return SingleForecast(
            timeStamp: lastUpdatedEpoch,
            date: Date(timeIntervalSince1970: TimeInterval(lastUpdatedEpoch)),
            tempC: tempC,
            tempF: tempF,
            conditionName: condition.text,
            isDay: isDay != 0,
            isRain: precipMm > 0 && tempC > 0,
            isSnow: precipMm > 0 && tempC <= 0,
            cloudCoverage: cloud,
            chanceOfRain: -1,
            chanceOfSnow: -1)
    }
}

extension ForecastDayDto {
    func toDayForecast() -> DayForecast {
        return DayForecast(
            date: Date(timeIntervalSince1970: TimeInterval(dateEpoch)),
            maxtempC: day.maxtempC,
            maxtempF: day.maxtempF,
            mintempC: day.mintempC,
            mintempF: day.mintempF,
            isRain: day.dailyWillItRain != 0,
            isSnow: day.dailyWillItSnow != 0,
            chanceOfRain: day.dailyChanceOfRain,
            chanceOfSnow: day.dailyChanceOfSnow,
            hours: hour.map() { $0.toSingleForecast() })
    }
}

extension HourDto {
    func toSingleForecast() -> SingleForecast {
        return SingleForecast(
            timeStamp: timeEpoch,
            date: Date(timeIntervalSince1970: TimeInterval(timeEpoch)),
            tempC: tempC,
            tempF: tempF,
            conditionName: condition.text,
            isDay: isDay != 0,
            isRain: willItRain != 0,
            isSnow: willItSnow != 0,
            cloudCoverage: cloud,
            chanceOfRain: chanceOfRain,
            chanceOfSnow: chanceOfSnow)
    }
}

fileprivate func getPlistKey(_ key: String) -> String? {
        return (Bundle.main.infoDictionary?[key] as? String)?
            .replacingOccurrences(of: "\\", with: "")
}

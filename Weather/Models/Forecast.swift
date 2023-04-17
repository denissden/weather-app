//
//  Forecast.swift
//  Weather
//
//  Created by deniss on 4/16/23.
//

import Foundation


struct Forecast {
    let location: Location
    let now: SingleForecast
    let days: [DayForecast]?
}

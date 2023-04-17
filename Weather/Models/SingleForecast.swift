//
//  SingleForecast.swift
//  Weather
//
//  Created by deniss on 4/16/23.
//

import Foundation


struct SingleForecast {
    let timeStamp: Int
    let date: Date
    
    let tempC, tempF: Double
    
    let conditionName: String
    let isDay, isRain, isSnow: Bool
    let cloudCoverage: Int
    let chanceOfRain, chanceOfSnow: Int
}

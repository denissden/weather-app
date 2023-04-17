//
//  DayForecast.swift
//  Weather
//
//  Created by deniss on 4/16/23.
//

import Foundation


struct DayForecast {
    let date: Date
    let maxtempC, maxtempF, mintempC, mintempF: Double
    
    let isRain, isSnow: Bool
    let chanceOfRain, chanceOfSnow: Int
    
    let hours: [SingleForecast]
}

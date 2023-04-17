//
//  TimeService.swift
//  Weather
//
//  Created by deniss on 4/15/23.
//

import Foundation


protocol TimeProvider {
    func getTimeOfDay() -> TimeOfDay
}

class DeviceTimeProvider: TimeProvider {
    func getTimeOfDay() -> TimeOfDay {
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
            case 6...11: return .morning
            case 12...16: return .afternoon
            case 17...21: return .evening
            default: return .night
        }
    }
}

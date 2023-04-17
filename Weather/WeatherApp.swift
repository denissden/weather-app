//
//  WeatherApp.swift
//  Weather
//
//  Created by deniss on 4/14/23.
//

import SwiftUI

@main
struct WeatherApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Dependencies.main)
        }
    }
}

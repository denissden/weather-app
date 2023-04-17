//
//  SingleDayView.swift
//  Weather
//
//  Created by deniss on 4/17/23.
//

import SwiftUI

struct SingleDayView: View {
    @State var dayForecast: DayForecast?
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color("AppBackground_1"), Color("AppBackground_2")]),
                           startPoint: .topLeading,
                           endPoint: .bottom)
            .edgesIgnoringSafeArea(.all)
            ScrollView {
                VStack {
                    
                    Text(dayForecast!.date.format("d, E"))
                        .font(.system (size: 32, weight: .medium))
                        .foregroundColor(Color("AppText"))
                        .padding()
                    
                    WeatherIcon(forecastInfo: dayForecast)
                        .frame(width: 180, height: 180)
                    
                    
                    Text("\(String(format: "%2.1f", dayForecast!.mintempC))° - \(String(format: "%2.1f", dayForecast!.maxtempC))")
                        .font(.system (size: 48, weight: .medium))
                        .foregroundColor(Color("AppText"))
                    
                    if dayForecast!.chanceOfRain != 0 {
                        Text("Chance of rain: \(dayForecast!.chanceOfRain)%")
                            .font(.system (size: 18, weight: .medium))
                            .foregroundColor(Color("AppText"))
                    }
                    
                    if dayForecast!.chanceOfSnow != 0 {
                        Text("Chance of rain: \(dayForecast!.chanceOfSnow)%")
                            .font(.system (size: 18, weight: .medium))
                            .foregroundColor(Color("AppText"))
                    }
                    
                    if dayForecast!.cloudCoverage != 0 {
                        Text("Cloud coverage: \(dayForecast!.cloudCoverage)%")
                            .font(.system (size: 18, weight: .medium))
                            .foregroundColor(Color("AppText"))
                    }
                
                }
                VStack {
                    VStack {
                        ForEach(dayForecast!.hours, id: \.date) { hour in
                            HStack {
                                Text(hour.date.format("hh:mm"))
                                    .font(.system (size: 18, weight: .medium))
                                    .foregroundColor(Color("AppText"))
                                Spacer()
                                WeatherIcon(forecastInfo: hour)
                                    .frame(width: 18, height: 18)
                                Text(String(format: "%2.1f", hour.tempC) + "°")
                                    .font(.system (size: 18, weight: .medium))
                                    .foregroundColor(Color("AppText"))
                            }
                        }
                    }
                    .padding()
                    .background(BlurEffect(style: .light))
                    .cornerRadius(10)
                }
                .padding()
                Spacer()
            }
        }
    }
}

struct SingleDayView_Previews: PreviewProvider {
    static var previews: some View {
        SingleDayView()
    }
}

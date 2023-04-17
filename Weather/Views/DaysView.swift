//
//  DaysView.swift
//  Weather
//
//  Created by deniss on 4/17/23.
//

import SwiftUI

struct DaysView: View {
    @State var days: [DayForecast]
    
    @State var forecastDays: Int
    let forecastDaysOptions: [Int]
    
    var body: some View {
        VStack {
            HStack {
                Button("\(forecastDays) days", action: cycleForecastDays)
                    .foregroundColor(Color("AppText"))
                    .padding([.leading, .trailing])
                    .padding([.top, .bottom], 4)
                    .background(BlurEffect(style: .light))
                    .cornerRadius(10)
                Spacer()
            }
            VStack {
                ForEach(days.prefix(forecastDays), id: \.date) { day in
                    NavigationLink(destination: SingleDayView(dayForecast: day)) {
                        HStack {
                            Text(day.date.format("d, E"))
                                .font(.system (size: 18, weight: .medium))
                                .foregroundColor(Color("AppText"))
                            Spacer()
                            WeatherIcon(forecastInfo: day)
                                .frame(width: 18, height: 18)
                            Text("\(String(format: "%2.1f", day.mintempC))° - \(String(format: "%2.1f", day.maxtempC))°")
                                .font(.system (size: 18, weight: .medium))
                                .foregroundColor(Color("AppText"))
                        }
                    }
                }
            }
            .padding()
            .background(BlurEffect(style: .light))
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func cycleForecastDays() {
        let currentIndex = forecastDaysOptions.firstIndex(of: forecastDays) ?? 0
        let nextIndex = (currentIndex + 1) % forecastDaysOptions.count
        forecastDays = forecastDaysOptions[nextIndex]
    }
}

struct DaysView_Previews: PreviewProvider {
    static var previews: some View {
        DaysView(days: [], forecastDays: 10, forecastDaysOptions: [10, 7, 3])
    }
}

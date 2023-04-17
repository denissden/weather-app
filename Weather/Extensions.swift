//
//  Extensions.swift
//  Weather
//
//  Created by deniss on 4/17/23.
//

import Foundation


extension Date {
    func format(_ formatString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = formatString
        return formatter.string(from: self)
    }
}

//
//  Double+Extension.swift
//  TQuizzer
//
//  Created by BAHATTIN KOC on 25.03.2024.
//

import Foundation

extension Double {
    func rounded(_ decimalPlaces: Int) -> Double {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}

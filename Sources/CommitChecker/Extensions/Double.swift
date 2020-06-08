//
//  Double.swift
//  
//
//  Created by Connor Ricks on 6/5/20.
//

import Foundation

extension Double {
    func percent(decimalPlaces: Int = 2) -> String {
        String(format: "%.2f%%", self * 100)
    }
}

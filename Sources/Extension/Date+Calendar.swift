//
//  Date+Calendar.swift
//  Pitstop-APP
//
//  Created by Ivan Voloshchuk on 27/12/24.
//

import Foundation

extension Date {
    func addingYears(_ years: Int) -> Date? {
        Calendar.current.date(byAdding: .year, value: years, to: self)
    }
}

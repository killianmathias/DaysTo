//
//  Event.swift
//  DaysTo
//
//  Created by Killian Mathias on 29/04/2026.
//

import Foundation
import SwiftData

@Model
final class DTEvent {
    var title: String
    var date: Date
    var icon: DTIcon
    var color: DTColor
    var creationDate: Date

    init(title: String, date: Date, icon: DTIcon = .calendar, color: DTColor = .blue) {
        self.title = title
        self.date = date
        self.icon = icon
        self.color = color
        self.creationDate = Date()
    }

    var daysRemaining: Int {
        let calendar = Calendar.current
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: start, to: end)
        return components.day ?? 0
    }
}


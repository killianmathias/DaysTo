//
//  Event.swift
//  DaysTo
//
//  Created by Killian Mathias on 29/04/2026.
//

import Foundation
import SwiftData

@Model
final class Event {
    var title: String
    var date: Date
    var icon: String
    var creationDate: Date
    
    init(title: String, date: Date, icon: String = "calendar") {
        self.title = title
        self.date = date
        self.icon = icon
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

//
//  Countdown.swift
//  DaysTo
//
//  Created by Killian Mathias on 06/04/2026.
//

import Foundation
import SwiftData

@Model
final class Countdown: Identifiable {
    private(set) var id: UUID

    var name: String
    var date: Date

    init(id: UUID = UUID(), name: String, date: Date = Date()) {
        self.id = id
        self.name = name
        self.date = date
    }

    convenience init() {
        self.init(name: "", date: Date())
    }
}

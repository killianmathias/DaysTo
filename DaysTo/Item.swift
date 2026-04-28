//
//  Item.swift
//  DaysTo
//
//  Created by Killian Mathias on 28/04/2026.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

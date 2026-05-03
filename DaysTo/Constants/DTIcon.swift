//
//  Icons.swift
//  DaysTo
//
//  Created by Killian Mathias on 03/05/2026.
//

import Foundation
import SwiftUI

enum DTIcon: String, Codable, CaseIterable {
    case calendar, airplane, gift, party, briefcase, heart, star, house, car, cart, sport, book

    var swiftUIImage: Image {
        switch self {
        case .calendar:
            return Image(systemName: "calendar")
        case .airplane:
            return Image(systemName: "airplane")
        case .gift:
            return Image(systemName: "gift")
        case .party:
            return Image(systemName: "party.popper")
        case .briefcase:
            return Image(systemName: "briefcase")
        case .heart:
            return Image(systemName: "heart")
        case .star:
            return Image(systemName: "star")
        case .house:
            return Image(systemName: "house")
        case .car:
            return Image(systemName: "car")
        case .cart:
            return Image(systemName: "cart")
        case .sport:
            return Image(systemName: "figure.run")
        case .book:
            return Image(systemName: "book")
        }
    }
}

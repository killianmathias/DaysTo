//
//  DTColor.swift
//  DaysTo
//
//  Created by Killian Mathias on 03/05/2026.
//
import Foundation
import SwiftUI

public enum DTColor: String, Codable, CaseIterable, Sendable {
    case blue, red, green, orange, purple, pink, yellow, teal, indigo, gray, cyan

    public var color: Color {
        switch self {
        case .blue: return .blue
        case .red: return .red
        case .green: return .green
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .yellow: return .yellow
        case .teal: return .teal
        case .indigo: return .indigo
        case .gray: return .gray
        case .cyan: return .cyan
        }
    }
}

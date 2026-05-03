//
//  DaysToWidgetMinimal.swift
//  DaysTo
//
//  Created by Killian Mathias on 03/05/2026.
//
import SwiftUI
import WidgetKit

struct MinimalWidgetEntryView: View {
    var entry: SimpleEntry

    var body: some View {
        ZStack {
            if entry.isPremium {
                if let event = entry.event {
                    event.color.color.opacity(0.2)

                    VStack(spacing: 4) {
                        event.icon.swiftUIImage
                            .font(.largeTitle)
                            .foregroundStyle(event.color.color)

                        Text("\(event.daysRemaining)")
                            .font(.system(size: 40, weight: .heavy, design: .rounded))
                    }
                } else {
                    Text("Vide")
                }
            } else {
                Color.gray.opacity(0.2)

                VStack(spacing: 8) {
                    Image(systemName: "lock.fill")
                        .font(.title2)
                        .foregroundStyle(.secondary)

                    Text("Widget Premium")
                        .font(.caption)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                }
            }
        }
    }
}

struct DaysToMinimalWidget: Widget {
    let kind: String = "DaysToMinimalWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            MinimalWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Compteur Minimaliste")
        .description("Allez à l'essentiel avec un grand compteur.")
        .supportedFamilies([.systemSmall])
    }
}

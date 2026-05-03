//
//  DaysToWidget.swift
//  DaysToWidget
//
//  Created by Killian Mathias on 28/04/2026.
//

import SwiftData
import SwiftUI
import WidgetKit

struct Provider: TimelineProvider {
    private func fetchNextEvent() -> Event? {
        let groupID = "group.com.killianmathias.daysto"

        guard let groupURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: groupID) else {
            return nil
        }

        let fileURL = groupURL.appendingPathComponent("Events.sqlite")

        guard let container = try? ModelContainer(
            for: Event.self,
            configurations: ModelConfiguration(url: fileURL)
        ) else { return nil }

        let backgroundContext = ModelContext(container)

        var descriptor = FetchDescriptor<Event>(sortBy: [SortDescriptor(\.date)])
        descriptor.fetchLimit = 1

        let events = try? backgroundContext.fetch(descriptor)
        return events?.first
    }

    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), event: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), event: nil)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let nextEvent = fetchNextEvent()
        let entry = SimpleEntry(date: Date(), event: nextEvent)

        let midnight = Calendar.current.startOfDay(for: Date()).addingTimeInterval(86400)
        let timeline = Timeline(entries: [entry], policy: .after(midnight))

        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let event: Event?
}

struct DaysToWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let event = entry.event {
                HStack {
                    Image(systemName: event.icon)
                        .foregroundStyle(.blue)
                    Text(event.title)
                        .font(.headline)
                        .lineLimit(1)
                }

                Text(String(localized: "\(event.daysRemaining) jours"))
                    .font(.system(.title, design: .rounded).bold())
                    .foregroundStyle(event.daysRemaining < 0 ? .red : .primary)

                Text(String(localized: "avant le grand jour"))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            } else {
                Text(String(localized: "Aucun évènement"))
                    .font(.headline)
                Text(String(localized: "Ouvrez l'app pour en ajouter un."))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct DaysToWidget: Widget {
    let kind: String = "DaysToWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DaysToWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("Prochain Évènement")
        .description("Affiche le temps restant avant votre prochaine échéance.")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

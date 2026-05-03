//
//  ContentView.swift
//  DaysTo
//
//  Created by Killian Mathias on 28/04/2026.
//
import SwiftData
import SwiftUI
import WidgetKit

struct ContentView: View {
    @Query(sort: \Event.date) private var events: [Event]
    @Environment(\.modelContext) private var modelContext
    @State private var showingAddEvent = false

    var body: some View {
        NavigationStack {
            List {
                if events.isEmpty {
                    ContentUnavailableView(String(localized: "Aucune échéance"), systemImage: "calendar.badge.plus", description: Text(String(localized: "Ajoutez votre premier évènement pour commencer le compte à rebours.")))
                } else {
                    ForEach(events) { event in
                        HStack(spacing: 16) {
                            Image(systemName: event.icon)
                                .font(.title)
                                .foregroundStyle(.blue)
                                .frame(width: 40)

                            VStack(alignment: .leading) {
                                Text(event.title)
                                    .font(.headline)
                                Text(event.date, format: .dateTime.day().month().year())
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }

                            Spacer()

                            // Le compteur de jours
                            VStack {
                                Text("\(event.daysRemaining)")
                                    .font(.title2.bold())
                                    .foregroundStyle(event.daysRemaining < 0 ? .red : .primary)
                                Text(String(localized: "jours"))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .onDelete(perform: deleteItems)
                }
            }
            .navigationTitle(String(localized: "Mes Échéances"))
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showingAddEvent = true }) {
                        Label(String(localized: "Ajouter"), systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView()
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(events[index])
            }
            do {
                try modelContext.save()
            } catch {
                print("Error while deleting : \(error)")
            }

            WidgetCenter.shared.reloadAllTimelines()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}

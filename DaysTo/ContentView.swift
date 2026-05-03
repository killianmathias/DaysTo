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
    @Query(sort: \DTEvent.date) private var events: [DTEvent]

    @Environment(\.modelContext) private var modelContext
    @Environment(StoreManager.self) private var storeManager

    @State private var showingPaywall = false
    @State private var showingAddEvent = false

    var body: some View {
        NavigationStack {
            List {
                if events.isEmpty {
                    ContentUnavailableView(String(localized: "Aucune échéance"), systemImage: "calendar.badge.plus", description: Text(String(localized: "Ajoutez votre premier évènement pour commencer le compte à rebours.")))
                } else {
                    ForEach(events) { event in
                        HStack(spacing: 16) {
                            event.icon.swiftUIImage
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
                    Button(action: {
                        if events.count >= 1, !storeManager.isPremium {
                            showingPaywall = true
                        } else {
                            showingAddEvent = true
                        }
                    }) {
                        Label("Ajouter", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddEvent) {
                AddEventView()
            }
            .sheet(isPresented: $showingPaywall) {
                PaywallView()
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
        .modelContainer(for: DTEvent.self, inMemory: true)
}

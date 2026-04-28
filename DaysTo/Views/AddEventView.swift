//
//  AddEventView.swift
//  DaysTo
//
//  Created by Killian Mathias on 29/04/2026.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    @State private var selectedIcon = "calendar"
    
    let icons = ["calendar", "airplane", "gift", "party.popper", "briefcase"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "Détails de l'échéance")) {
                    TextField(String(localized: "Titre (ex: Vacances au Japon)"), text: $title)
                    // On demande uniquement la date, pas l'heure
                    DatePicker(String(localized:"Date"), selection: $date, displayedComponents: .date)
                }
                
                Section(String(localized:"Icône")) {
                    Picker(String(localized: "Choisir une icône"), selection: $selectedIcon) {
                        ForEach(icons, id: \.self) { icon in
                            Image(systemName: icon).tag(icon)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            .navigationTitle(String(localized: "Nouvel Évènement"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized:"Annuler")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized:"Ajouter")) { saveEvent() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveEvent() {
            let newEvent = Event(title: title, date: date, icon: selectedIcon)

            modelContext.insert(newEvent)
 
            do {
                try modelContext.save()
            } catch {
                print("Erreur de sauvegarde : \(error)")
            }
            
            WidgetCenter.shared.reloadAllTimelines()
            
            dismiss()
        }
}
#Preview {
    AddEventView()
}

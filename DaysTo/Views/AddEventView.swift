//
//  AddEventView.swift
//  DaysTo
//
//  Created by Killian Mathias on 29/04/2026.
//

import SwiftData
import SwiftUI
import WidgetKit

struct AddEventView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var date = Date()
    @State private var selectedIcon: DTIcon = .calendar
    @State private var selectedColor: DTColor = .blue
    
    var body: some View {
        NavigationStack {
            Form {
                Section(String(localized: "Détails de l'échéance")) {
                    TextField(String(localized: "Titre (ex: Vacances au Japon)"), text: $title)
                    DatePicker(String(localized: "Date"), selection: $date, displayedComponents: .date)
                }
                
                Section(String(localized: "Icône")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(DTIcon.allCases, id: \.self) { icon in
                                icon.swiftUIImage
                                    .font(.title2)
                                    .foregroundStyle(selectedIcon == icon ? .white : .primary)
                                    .padding(10)
                                    .background(selectedIcon == icon ? selectedColor.color : Color.gray.opacity(0.2))
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        selectedIcon = icon
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                Section(String(localized: "Couleur")) {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(DTColor.allCases, id: \.self) { color in
                                Circle()
                                    .fill(color.color)
                                    .frame(width: 40, height: 40)
                                    .overlay(
                                        Circle()
                                            .stroke(Color.primary, lineWidth: selectedColor == color ? 3 : 0)
                                    )
                                    .onTapGesture {
                                        selectedColor = color
                                    }
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
            }
            .navigationTitle(String(localized: "Nouvel Évènement"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(String(localized: "Annuler")) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(String(localized: "Ajouter")) { saveEvent() }
                        .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
        }
    }
    
    private func saveEvent() {
        let newEvent = DTEvent(title: title, date: date, icon: selectedIcon)

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

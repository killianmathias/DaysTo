//
//  PaywallView.swift
//  DaysTo
//
//  Created by Killian Mathias on 03/05/2026.
//

import SwiftUI
import StoreKit

struct PaywallView: View {
    @Environment(StoreManager.self) private var storeManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                Image(systemName: "star.circle.fill")
                    .font(.system(size: 80))
                    .foregroundStyle(.yellow)
                
                Text("Passez à la vitesse supérieure")
                    .font(.title.bold())
                    .multilineTextAlignment(.center)
                
                VStack(alignment: .leading, spacing: 15) {
                    Label("Évènements illimités", systemImage: "infinity")
                    Label("Widgets exclusifs et minimalistes", systemImage: "square.grid.2x2")
                    Label("Soutien au développeur", systemImage: "heart.fill")
                }
                .font(.headline)
                
                Spacer()
                
                if let product = storeManager.products.first {
                    Button(action: {
                        Task {
                            try? await storeManager.purchase(product)
                            if storeManager.isPremium {
                                dismiss()
                            }
                        }
                    }) {
                        Text("Débloquer pour \(product.displayPrice)")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    }
                } else {
                    ProgressView("Chargement des produits...")
                }
                
                Button("Restaurer les achats") {
                    Task {
                        try? await AppStore.sync()
                        await storeManager.updateCustomerProductStatus()
                        if storeManager.isPremium { dismiss() }
                    }
                }
                .font(.footnote)
                .foregroundStyle(.secondary)
            }
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Fermer") { dismiss() }
                }
            }
        }
    }
}

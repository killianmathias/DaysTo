//
//  StoreManager.swift
//  DaysTo
//
//  Created by Killian Mathias on 03/05/2026.
//

import Foundation
import StoreKit
import SwiftUI

@Observable
@MainActor
class StoreManager {
    var products: [Product] = []
    var isPremium: Bool = false
    
    private let productID = "premium.unlock"
    private let appGroupID = "group.com.killianmathias.daysto"
    
    init() {
        _ = listenForTransactions()
        
        Task {
            await fetchProducts()
            await updateCustomerProductStatus()
        }
    }

    func fetchProducts() async {
        do {
            products = try await Product.products(for: [productID])
        } catch {
            print("Erreur de récupération des produits : \(error)")
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            await transaction.finish()
            await updateCustomerProductStatus()
        case .userCancelled, .pending:
            break
        @unknown default:
            break
        }
    }

    func updateCustomerProductStatus() async {
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                if transaction.productID == productID {
                    isPremium = true
                    updateWidgetStatus()
                    return
                }
            } catch {
                print("Transaction non vérifiée")
            }
        }
        isPremium = false
        updateWidgetStatus()
    }
    
    private func updateWidgetStatus() {
        if let sharedDefaults = UserDefaults(suiteName: appGroupID) {
            sharedDefaults.set(isPremium, forKey: "isPremium")
        }
    }
    
    private nonisolated func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func listenForTransactions() -> Task<Void, Never> {
        return Task.detached {
            for await result in Transaction.updates {
                do {
                    let transaction = try self.checkVerified(result)
                    await transaction.finish()
                    await self.updateCustomerProductStatus()
                } catch {
                    print("Erreur de transaction : \(error)")
                }
            }
        }
    }
}

enum StoreError: Error {
    case failedVerification
}

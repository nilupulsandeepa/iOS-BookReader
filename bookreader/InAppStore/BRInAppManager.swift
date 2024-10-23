//
//  BRInAppManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-19.
//

import StoreKit

public class BRInAppManager {
    
    //---- MARK: Properties
    public static var shared: BRInAppManager = BRInAppManager()
    
    private var g_InAppNonRenewableProducts: [String: Product] = [:]
    private var g_InAppNonConsumableProducts: [String: Product] = [:]
    private var g_AllInAppProducts: [String: Product] = [:]
    
    //---- MARK: Action Methods
    public func loadInAppProducts() async {
        let m_NonConsumableProducts: [String] = [
            BRNameSpaces.InAppConsumableProducts.inAppConsumableTier1,
            BRNameSpaces.InAppConsumableProducts.inAppConsumableTier2,
            BRNameSpaces.InAppConsumableProducts.inAppConsumableTier3,
        ]
        let m_NonRenewableProducts: [String] = [
            BRNameSpaces.InAppNonRenewableSubscriptionProducts.inApp7DaysRent,
            BRNameSpaces.InAppNonRenewableSubscriptionProducts.inApp14DaysRent,
        ]
        let m_AllProducts: [String] = m_NonConsumableProducts + m_NonRenewableProducts
        if let m_InAppProducts: [Product] = try? await Product.products(for: m_AllProducts) {
            print("")
            for m_Product in m_InAppProducts {
                switch m_Product.type {
                case .consumable:
                    g_InAppNonConsumableProducts[m_Product.id] = m_Product
                    g_AllInAppProducts[m_Product.id] = m_Product
                case .nonRenewable:
                    g_InAppNonRenewableProducts[m_Product.id] = m_Product
                    g_AllInAppProducts[m_Product.id] = m_Product
                default:
                    _ = "No Action"
                }
            }
        }
    }
    
    public func purchase(productId: String) async {
        if let m_PurchaseResult = try? await g_AllInAppProducts[productId]!.purchase() {
            switch m_PurchaseResult {
            case .success(let verification):
                switch verification {
                case .verified(let transaction):
                    await transaction.finish()
                    print("Purchase Success")
                    purchaseSuccess(productId: g_AllInAppProducts[productId]!)
                default:
                    purchaseFailed()
                    print("Error")
                }
            default:
                print("Purchase Failed")
            }
        }
    }
    
    public func listenForTransactions() {
        Task {
            for await result in Transaction.updates {
                print("Listining")
                switch result {
                case .verified(let transaction):
                    await transaction.finish()
                default:
                    print("Listining Error")
                }
            }
        }
    }
    
    //---- MARK: Helper methods
    private func purchaseSuccess(productId: Product) {
        NotificationCenter.default.post(
            name: Notification.Name(BRNameSpaces.NotificationIdentifiers.purchaseSuccessNotification),
            object: nil,
            userInfo: ["productId": productId.id]
        )
    }
    
    private func purchaseFailed() {
        NotificationCenter.default.post(
            name: NSNotification.Name(BRNameSpaces.NotificationIdentifiers.purchaseFailedNotification),
            object: nil,
            userInfo: nil
        )
    }
}

//
//  InAppManager.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-19.
//

import StoreKit

public class InAppManager {
    
    //---- MARK: Properties
    public static var shared: InAppManager = InAppManager()
    
    public let inAppProductsDictionary: [String: String] = [
        "tier1": NameSpaces.InAppConsumableProducts.inAppConsumableTier1,
        "tier2": NameSpaces.InAppConsumableProducts.inAppConsumableTier2,
        "tier3": NameSpaces.InAppConsumableProducts.inAppConsumableTier3
    ]
    private var inAppNonRenewableProducts: [String: Product] = [:]
    private var inAppNonConsumableProducts: [String: Product] = [:]
    private var allInAppProducts: [String: Product] = [:]
    
    //---- MARK: Action Methods
    public func loadInAppProducts() async {
        let nonConsumableProducts: [String] = [
            NameSpaces.InAppConsumableProducts.inAppConsumableTier1,
            NameSpaces.InAppConsumableProducts.inAppConsumableTier2,
            NameSpaces.InAppConsumableProducts.inAppConsumableTier3,
        ]
        let nonRenewableProducts: [String] = [
            NameSpaces.InAppNonRenewableSubscriptionProducts.inApp7DaysRent,
            NameSpaces.InAppNonRenewableSubscriptionProducts.inApp14DaysRent,
        ]
        let allProducts: [String] = nonConsumableProducts + nonRenewableProducts
        if let inAppProducts: [Product] = try? await Product.products(for: allProducts) {
            print("")
            for product in inAppProducts {
                switch product.type {
                case .consumable:
                    inAppNonConsumableProducts[product.id] = product
                    allInAppProducts[product.id] = product
                case .nonRenewable:
                    inAppNonRenewableProducts[product.id] = product
                    allInAppProducts[product.id] = product
                default:
                    _ = "No Action"
                }
            }
        }
    }
    
    public func purchase(productId: String) {
        Task(priority: .userInitiated) {
            if let purchaseResult = try? await allInAppProducts[productId]!.purchase() {
                switch purchaseResult {
                case .success(let verification):
                    switch verification {
                    case .verified(let transaction):
                        await transaction.finish()
                        print("Purchase Success")
                        purchaseSuccess(productId: allInAppProducts[productId]!)
                    default:
                        purchaseFailed()
                        print("Error")
                    }
                default:
                    print("Purchase Failed")
                }
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
    
    public func getProductPrice(inAppProduct: String) -> String {
        if let product: Product = inAppNonConsumableProducts[inAppProductsDictionary[inAppProduct] ?? "none"] {
            return product.displayPrice
        }
        return "\(0.0)"
    }
    
    //---- MARK: Helper methods
    private func purchaseSuccess(productId: Product) {
        NotificationCenter.default.post(
            name: Notification.Name(NameSpaces.NotificationIdentifiers.purchaseSuccessNotification),
            object: nil,
            userInfo: ["productId": productId.id]
        )
    }
    
    private func purchaseFailed() {
        NotificationCenter.default.post(
            name: NSNotification.Name(NameSpaces.NotificationIdentifiers.purchaseFailedNotification),
            object: nil,
            userInfo: nil
        )
    }
}

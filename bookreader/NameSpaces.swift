//
//  NameSpaces.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import Foundation

public struct NameSpaces {
    public struct UserDefaultIndentifiers {
        public static let currentUserKey: String = "com.bookreader.userdefaults.currentuserkey"
    }
    
    public struct FirebasePaths {
        public static let recentBooks: String = "/recent_books"
        public static let books: String = "/books"
    }
    
    public struct InAppNonRenewableSubscriptionProducts {
        public static let inApp7DaysRent: String = "com.bookreader.test.7dayrental"
        public static let inApp14DaysRent: String = "com.bookreader.test.14dayrental"
    }
    
    public struct InAppConsumableProducts {
        public static let inAppConsumableTier1: String = "com.bookreader.test.booktier1"
        public static let inAppConsumableTier2: String = "com.bookreader.test.booktier2"
        public static let inAppConsumableTier3: String = "com.bookreader.test.booktier3"
    }
    
    public struct NotificationIdentifiers {
        public static let purchaseSuccessNotification: String = "com.bookreader.notification.purchasesuccess"
        public static let purchaseFailedNotification: String = "com.bookreader.notification.purchasefailed"
        
        public static let sessionUserUpdated: String = "com.bookreader.notification.sessionuserupdated"
        public static let sessionUserPurchasedBook: String = "com.bookreader.notification.sessionUserPurchasedBook"
    }
}

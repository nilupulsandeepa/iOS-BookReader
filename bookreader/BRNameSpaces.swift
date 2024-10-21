//
//  BRNameSpaces.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import Foundation

public struct BRNameSpaces {
    public struct UserDefaultIndentifiers {
        public static let currentUserKey: String = "com.bookreader.userdefaults.currentuserkey"
    }
    
    public struct FirebasePaths {
        public static let recentBooks: String = "/recent_books"
        public static let books: String = "/books"
    }
    
    public struct InAppNonRenewableSubscriptionProducts {
        public static let inApp7DaysRent = "com.bookreader.test.7dayrental"
        public static let inApp14DaysRent = "com.bookreader.test.7dayrental"
    }
    
    public struct InAppNonConsumableProducts {
        public static let inAppConsumableTier1 = "com.bookreader.test.booktier1"
        public static let inAppConsumableTier2 = "com.bookreader.test.booktier2"
        public static let inAppConsumableTier3 = "com.bookreader.test.booktier3"
    }
}

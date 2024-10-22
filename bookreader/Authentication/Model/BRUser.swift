//
//  BRUser.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import SwiftUI

public class BRUser: Codable {
    public var email: String!
    public var id: String!
    public var name: String!
    public var rentedBooks: [String: BRUserBookRecord]?
    public var purchasedBooks: [String: BRUserBookRecord]?
    
    //---- Non key
    public var profilePictureURL: String?
        
    enum CodingKeys: String, CodingKey {
        case email = "email"
        case id = "id"
        case name = "name"
        case rentedBooks = "rented_books"
        case purchasedBooks = "purchased_books"
        case profilePictureURL = "profile_picture_Url"
    }
}

public class BRUserBookRecord: Codable {
    public var bookId: String!
    public var isExpired: Bool!
    public var rentedTimestamp: Int!
    
    enum CodingKeys: String, CodingKey {
        case bookId = "book_id"
        case isExpired = "isExpired"
        case rentedTimestamp = "rented_timestamp"
    }
}

//
//  Book.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-14.
//

import Foundation

public struct Book: Hashable, Codable, Identifiable {
    public var id: String = ""
    public var name: String = ""
    public var description: String? = ""
    public var authorId: String? = nil
    public var authorName: String? = nil
    public var progress: Int? = nil
    public var isCloudSynced: Bool? = nil
    public var isRented: Bool? = nil
    public var priceTier: String? = nil
    public var rentExpirationTimestamp: Int? = nil
    public var isExpired: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case authorId = "authorId"
        case authorName = "authorName"
        case priceTier = "priceTier"
        case rentExpirationTimestamp = "rentExpirationTimestamp"
        case isExpired = "isExpired"
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

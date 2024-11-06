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
    public var authorId: String? = nil
    public var authorName: String? = nil
    public var progress: Int? = nil
    public var isCloudSynced: Bool? = nil
    public var isRented: Bool? = nil
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
}

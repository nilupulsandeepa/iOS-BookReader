//
//  BookDetails.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-17.
//

import Foundation

public struct BookDetails: Hashable, Codable {
    public var id: String
    public var name: String
    public var description: String
    public var authorId: String
    public var authorName: String
    public var priceTier: String
}

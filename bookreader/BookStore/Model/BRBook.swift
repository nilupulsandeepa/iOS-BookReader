//
//  BRBook.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-14.
//

import Foundation

public struct BRBook: Hashable, Codable {
    public var ID: String {
        return g_ID
    }
    
    public var name: String {
        return g_Name
    }
    
    private var g_ID: String = ""
    private var g_Name: String = ""
    
    enum CodingKeys: String, CodingKey {
        case g_ID = "id"
        case g_Name = "name"
    }
    
    init(g_ID: String, g_Name: String) {
        self.g_ID = g_ID
        self.g_Name = g_Name
    }
}

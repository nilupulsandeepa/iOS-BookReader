//
//  BRBook.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-14.
//

import Foundation

public struct BRBook {
    public var ID: String {
        return g_ID
    }
    
    public var name: String {
        return g_Name
    }
    
    private var g_ID: String = ""
    private var g_Name: String = ""
}

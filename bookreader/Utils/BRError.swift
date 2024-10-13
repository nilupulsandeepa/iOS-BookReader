//
//  BRError.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-13.
//

import SwiftUI

public enum BRError: Error {
    case fileError
    
    var localizedDescription: String {
        return "File Error"
    }
}

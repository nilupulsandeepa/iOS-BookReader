//
//  Utils.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-11-13.
//

import Foundation

public class Utils {
    public static func delayExecution(seconds: TimeInterval, completion: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }
}

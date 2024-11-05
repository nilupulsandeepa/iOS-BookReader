//
//  Extensions.swift
//  bookreader
//
//  Created by Nilupul Sandeepa on 2024-10-12.
//

import UIKit

extension UIColor {
    public convenience init(red: Int, green: Int, blue: Int) {
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
}

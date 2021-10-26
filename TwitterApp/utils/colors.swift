//
//  colors.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    /// customBlue(red: 30/255, green: 160/255, blue: 240/255)
    static let customBlue = UIColor.rgb(red: 30, green: 160, blue: 240)

}


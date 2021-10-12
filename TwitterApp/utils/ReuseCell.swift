//
//  ReuseCell.swift
//  TwitterApp
//
//  Created by L on 2021/10/11.
//

import UIKit

//extension UITableViewCell {
//    static var id: String {
//        return "\(Self.self)"
//    }
//}

extension UICollectionViewCell {
    static var id: String {
        return "\(Self.self)"
    }
}

extension UICollectionViewController {
    static var id: String {
        return "\(Self.self)"
    }
}

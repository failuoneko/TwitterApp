//
//  UIButton+CreatButton.swift
//  TwitterApp
//
//  Created by L on 2021/10/17.
//

import UIKit

extension UIButton {
    
    class func creatButton(withImageName imageName: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: imageName), for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .darkGray
        button.snp.makeConstraints{ $0.size.equalTo(20) }
        return button
    }
    
}

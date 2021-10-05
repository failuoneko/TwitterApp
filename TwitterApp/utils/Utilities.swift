//
//  Utilities.swift
//  TwitterApp
//
//  Created by L on 2021/10/2.
//

import UIKit

class Utilities {
    
    func inputContainerView(withImage image: UIImage?, textField: UITextField) -> UIView {
        let view = UIView()
        let imageView = UIImageView()
        view.snp.makeConstraints{ $0.height.equalTo(50) }
        
        imageView.image = image
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(10)
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(25)
        }
        
        view.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right).inset(-10)
            make.right.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview()
        }
        
        let underline = UIView()
        underline.backgroundColor = .white
        view.addSubview(underline)
        underline.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(10)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.8)
        }
        
        return view
    }
    
    func textField(withPlaceholder placeholder:String) -> UITextField {
        let textField = UITextField()
        textField.textColor = .white
        textField.font = UIFont.systemFont(ofSize: 20)
        textField.attributedPlaceholder = NSAttributedString(string: placeholder,
                                                             attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        return textField
    }
    
    func attributedButton(_ firstText: String, _ secondText: String) -> UIButton {
        let button = UIButton(type: .system)
        let firstAttributedtitle = NSAttributedString(string: firstText,
                                                 attributes: [.foregroundColor: UIColor.white,
                                                              .font: UIFont.systemFont(ofSize: 20)])
        let secondAttributedtitle = NSAttributedString(string: secondText,
                                                      attributes: [.foregroundColor: UIColor.white,
                                                                   .font: UIFont.boldSystemFont(ofSize: 20)])
        let attributedText = NSMutableAttributedString()
        attributedText.append(firstAttributedtitle)
        attributedText.append(secondAttributedtitle)
        button.setAttributedTitle(attributedText, for: .normal)
        return button
    }
    
}


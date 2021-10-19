//
//  CaptionTextView.swift
//  TwitterApp
//
//  Created by L on 2021/10/10.
//

import UIKit

class CaptionTextView: UITextView {
    
    // MARK: - Properties
    
    let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "What's happening?"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    
    // MARK: - Lifecycle

    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 16)
        isScrollEnabled = false
        snp.makeConstraints{ $0.height.equalTo(150) }
        
        addSubview(placeholderLabel)
        placeholderLabel.snp.makeConstraints{ $0.top.equalToSuperview().inset(10) }
        placeholderLabel.snp.makeConstraints{ $0.left.equalToSuperview().inset(4) }
        
        NotificationCenter.default.addObserver(self, selector: #selector(textInputChange), name: UITextView.textDidChangeNotification, object: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors

    @objc func textInputChange() {
        placeholderLabel.isHidden = !text.isEmpty
        
//        if text.isEmpty {
//            placeholderLabel.isHidden = false
//        } else {
//            placeholderLabel.isHidden = true
//        }
    }
    
    
}

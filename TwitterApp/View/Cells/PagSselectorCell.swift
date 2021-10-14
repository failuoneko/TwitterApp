//
//  PagSselectorCell.swift
//  TwitterApp
//
//  Created by L on 2021/10/13.
//

import UIKit

class PagSselectorCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    var option: PagSelectorViewOptions? {
        didSet {
            titleLabel.text = option?.description
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Page"
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            titleLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 16) : UIFont.systemFont(ofSize: 14)
            titleLabel.textColor = isSelected ? .customBlue : .lightGray
        }
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{ $0.center.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - Selectors
    
        
    // MARK: - Helpers
        

}

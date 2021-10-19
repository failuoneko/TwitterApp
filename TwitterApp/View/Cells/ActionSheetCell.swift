//
//  ActionSheetCell.swift
//  TwitterApp
//
//  Created by L on 2021/10/18.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    // MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet { configure() }
    }
    
    private let actionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "twitter_logo")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "text option"
        return label
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Helpers
    
    func configure() {
        titleLabel.text = option?.description
    }
    
    func configureUI() {
        addSubview(actionImageView)
        actionImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(8)
            make.size.equalTo(40)
        }
        
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(actionImageView.snp.right).inset(-12)
        }
    }
}

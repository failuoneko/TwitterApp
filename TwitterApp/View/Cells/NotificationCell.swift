//
//  NotificationCell.swift
//  TwitterApp
//
//  Created by L on 2021/10/20.
//

import UIKit

protocol NotificationCellDelegate: AnyObject {
    func tapProfileImage(_ cell: NotificationCell)
    func tapFollow(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {
    
    // MARK: - Properties
    
    var notification: Notification? {
        didSet { configure() }
    }
    
    weak var delegate: NotificationCellDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.snp.makeConstraints{ $0.size.equalTo(40) }
        imageView.layer.cornerRadius = 40 / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.customBlue, for: .normal)
        button.backgroundColor = .white
        button.layer.borderColor = UIColor.customBlue.cgColor
        button.layer.borderWidth = 2
        button.addTarget(self, action: #selector(followTapped), for: .touchUpInside)
        return button
    }()
    
    let notificationLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Notification Text message."
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
    
    @objc func profileImageViewTapped() {
        delegate?.tapProfileImage(self)
    }
    
    @objc func followTapped() {
        delegate?.tapFollow(self)
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        
        guard let notification = notification else { return }
        let viewModel = NotificationViewModel(notification: notification)
        
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
        notificationLabel.attributedText = viewModel.notificationText
        
        followButton.isHidden = viewModel.shouldHideFollowButton
        followButton.setTitle(viewModel.followButtonText, for: .normal)
        
    }
    
    func configureUI() {
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.spacing = 10
        stack.alignment = .center
        
        contentView.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview().inset(12)
        }
        
        addSubview(followButton)
        followButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(80)
            make.height.equalTo(30)
            make.right.equalToSuperview().inset(12)
            followButton.layer.cornerRadius = 30 / 2
        }
        
    }
}

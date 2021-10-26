//
//  ProfileHeader.swift
//  TwitterApp
//
//  Created by L on 2021/10/12.
//

import UIKit

protocol ProfileHeaderDelegate: AnyObject {
    func dismissal()
    func editProfileFollow(_ header: ProfileHeader)
    func didSelect(page: PageSelectorViewOptions)
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet { configure() }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let pagSselectorBar = PagSelectorView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .customBlue
        view.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(40)
            make.left.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.setImage(UIImage(systemName: "arrow.backward.circle"), for: .normal)
        button.addTarget(self, action: #selector(dismissal), for: .touchUpInside)
        return button
    }()
    
    private let bigProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 4
        return imageView
    }()
    
    lazy var editProfileFollowButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.customBlue.cgColor
        button.layer.borderWidth = 1.5
        button.setTitle("Loading", for: .normal)
        button.setTitleColor(.customBlue, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(editProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "fullname"
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@username"
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(followingLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
//        label.text = "0 followers"
        let tap = UITapGestureRecognizer(target: self, action: #selector(followersLabelTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tap)
        return label
    }()
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func dismissal() {
        delegate?.dismissal()
    }
    
    @objc func editProfileFollow() {
        delegate?.editProfileFollow(self)
    }
    
    @objc func followingLabelTapped() {
        
    }
    
    @objc func followersLabelTapped() {
        
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
        
        bigProfileImageView.kf.setImage(with: user.profileImageUrl)
        editProfileFollowButton.setTitle(viewModel.editProfileFollowButtonTitle, for: .normal)
        followingLabel.attributedText = viewModel.followingString
        followersLabel.attributedText = viewModel.followersString
        usernameLabel.text = viewModel.usernameText

        fullnameLabel.text = user.fullname
        bioLabel.text = user.bio
        
    }
    
    func configureUI() {
        
        pagSselectorBar.delegate = self
        
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(120)
        }
        
        addSubview(bigProfileImageView)
        bigProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).inset(24)
            make.left.equalToSuperview().inset(8)
            make.size.equalTo(80)
            bigProfileImageView.layer.cornerRadius = 80 / 2
        }
        
        addSubview(editProfileFollowButton)
        editProfileFollowButton.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).inset(-12)
            make.right.equalToSuperview().inset(12)
            make.width.equalTo(100)
            make.height.equalTo(36)
            editProfileFollowButton.layer.cornerRadius = 36 / 2
        }
        
        let userInfoStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillProportionally
        userInfoStack.spacing = 10
        
        addSubview(userInfoStack)
        userInfoStack.snp.makeConstraints { make in
            make.top.equalTo(bigProfileImageView.snp.bottom).inset(-8)
            make.left.right.equalToSuperview().inset(12)
        }
        
        addSubview(pagSselectorBar)
        pagSselectorBar.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        let followLabelStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followLabelStack.axis = .horizontal
        followLabelStack.spacing = 4
        followLabelStack.distribution = .fillEqually
        
        addSubview(followLabelStack)
        followLabelStack.snp.makeConstraints { make in
            make.top.equalTo(userInfoStack.snp.bottom).inset(-8)
            make.left.equalToSuperview().inset(12)
        }
        
    }
}

// MARK: - PagSelectorViewDelegate

extension ProfileHeader: PagSelectorViewDelegate {
    func pagSelectorView(_ view: PagSelectorView, didSelect index: Int) {
        
        guard let page = PageSelectorViewOptions(rawValue: index) else { return }
        
        print("DEBUG: delegate action from header to controller with page : [\(page)]")
        
        delegate?.didSelect(page: page)
        
    }
}

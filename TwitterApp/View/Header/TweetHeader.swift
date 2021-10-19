//
//  TweetHeader.swift
//  TwitterApp
//
//  Created by L on 2021/10/16.
//

import UIKit

protocol TweetHeaderDelegate: AnyObject {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    weak var delegate: TweetHeaderDelegate?
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.snp.makeConstraints{ $0.size.equalTo(48) }
        imageView.layer.cornerRadius = 48 / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        imageView.addGestureRecognizer(tap)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "fullname Loading..."
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        label.text = "@username Loading..."
        return label
    }()
    
    private let captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Caption Loading..."
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 1
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "0:00 AM - 01/01/1970"
        return label
    }()
    
    private lazy var optionsButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(systemName: "chevron.down.circle"), for: .normal)
        button.addTarget(self, action: #selector(showActionSheet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var retweetsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0 Retweets"
        return label
    }()
    
    private lazy var likesLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "0 Likes"
        return label
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
//        view.backgroundColor = .red
        
        let topDivider = UIView()
        topDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(topDivider)
        topDivider.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(1)
        }
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(bottomDivider)
        bottomDivider.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(8)
            make.height.equalTo(1)
        }
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel,likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }
        
        return view
    }()
    
    // Action: comment/retweet/like/share
    private lazy var commentButton: UIButton = {
        let button = UIButton.creatButton(withImageName: "bubble.left")
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton.creatButton(withImageName: "arrow.2.squarepath")
        button.addTarget(self, action: #selector(retweetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton.creatButton(withImageName: "heart")
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton.creatButton(withImageName: "square.and.arrow.up")
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        backgroundColor = .white
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func profileImageViewTapped() {
        print("DEBUG: profileImageViewTapped")
    }
    
    @objc func showActionSheet() {
        delegate?.showActionSheet()
    }
    
    @objc func commentButtonTapped() {
        
    }
    
    @objc func retweetButtonTapped() {
        
    }
    
    @objc func likeButtonTapped() {
        
    }
    
    @objc func shareButtonTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configure() {
        
        guard  let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
        captionLabel.text = tweet.caption
        fullnameLabel.text = tweet.user.fullname
        usernameLabel.text = viewModel.usernameText
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetAttributedTextString
        likesLabel.attributedText = viewModel.likeAttributedTextString
        
    }
    
    func configureUI() {
        
        let labelStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        labelStack.axis = .vertical
        labelStack.spacing = -6
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        stack.spacing = 12
        
        addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.left.equalToSuperview().inset(16)
        }
        
        addSubview(captionLabel)
        captionLabel.snp.makeConstraints { make in
            make.top.equalTo(stack.snp.bottom).inset(-20)
            make.left.right.equalToSuperview().inset(16)
        }
        
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(captionLabel.snp.bottom).inset(-20)
            make.left.equalToSuperview().inset(16)
        }
        
        addSubview(optionsButton)
        optionsButton.snp.makeConstraints { make in
            make.centerY.equalTo(stack)
            make.right.equalToSuperview().inset(16)
        }
        
        addSubview(statsView)
        statsView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).inset(-12)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.spacing = 70
        addSubview(actionStack)
        actionStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(statsView.snp.bottom).inset(-16)
        }
        
    }
    
}

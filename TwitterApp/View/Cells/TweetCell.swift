//
//  TweetCell.swift
//  TwitterApp
//
//  Created by L on 2021/10/11.
//

import UIKit
import ActiveLabel

protocol TweetCellDelegate: AnyObject {
    func profileImageViewTapped(_ cell: TweetCell)
    func replyTapped(_ cell: TweetCell)
    func likeTapped(_ cell: TweetCell)
    func fetchUser(withUsername username: String)
}

class TweetCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    // 讀取資料要時間，有可能沒資料，所以用問號。
    var tweet: Tweet? {
        didSet { configure() }
    }
    
    weak var delegate: TweetCellDelegate?
    
    private let infoLabel = UILabel()
    
    private let replyToUserLabel : ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .customBlue

//        label.text = " replying to @username"
//        let tap = UITapGestureRecognizer(target: self, action: #selector())
//        label.addGestureRecognizer(tap)
//        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .customBlue
        label.hashtagColor = .customBlue
//        label.backgroundColor = .blue
//        label.text = "test caption"
        return label
    }()
    
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
    
    // comment/retweet/like/share
    private lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "bubble.left"), for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .darkGray
        button.snp.makeConstraints{ $0.size.equalTo(20) }
        button.addTarget(self, action: #selector(commentButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.2.squarepath"), for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .darkGray
        button.snp.makeConstraints{ $0.size.equalTo(20) }
        button.addTarget(self, action: #selector(retweetButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .darkGray
        button.snp.makeConstraints{ $0.size.equalTo(20) }
        button.addTarget(self, action: #selector(likeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .darkGray
        button.snp.makeConstraints{ $0.size.equalTo(20) }
        button.addTarget(self, action: #selector(shareButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGroupedBackground
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
        configureMention()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func profileImageViewTapped() {
        delegate?.profileImageViewTapped(self)
    }
    
    @objc func commentButtonTapped() {
        delegate?.replyTapped(self)
    }
    
    @objc func retweetButtonTapped() {
        
    }
    
    @objc func likeButtonTapped() {
        delegate?.likeTapped(self)
    }
    
    @objc func shareButtonTapped() {
        
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        
        backgroundColor = .white
        
        let infoStack = UIStackView(arrangedSubviews: [infoLabel, replyToUserLabel, captionLabel])
        infoStack.axis = .vertical
        #warning("BUG?")
        infoStack.distribution = .fill
        infoStack.spacing = 4
        
        let imageAndInfoStack = UIStackView(arrangedSubviews: [profileImageView, infoStack])
        imageAndInfoStack.axis = .horizontal
        imageAndInfoStack.distribution = .fillProportionally
        imageAndInfoStack.spacing = 10
        imageAndInfoStack.alignment = .leading
        
        #warning("imageAndInfoStack")
        addSubview(imageAndInfoStack)
        imageAndInfoStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
        }
        
//        infoLabel.text = "Harry Potter @account"
        infoLabel.font = UIFont.systemFont(ofSize: 14)
        
        let actionStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        actionStack.axis = .horizontal
        //        actionStack.distribution = .fillProportionally
        actionStack.spacing = 70
        addSubview(actionStack)
        actionStack.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }
        
        addSubview(underlineView)
        underlineView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)

        profileImageView.kf.setImage(with: viewModel.profileImageUrl)
        infoLabel.attributedText = viewModel.userInfoText
        captionLabel.text = tweet.caption
        
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        
        replyToUserLabel.isHidden = viewModel.shouldHideReplyToUserLabel
        replyToUserLabel.text = viewModel.replyText
    }
    
    // MARK: - configureMention
    
    func configureMention() {
        captionLabel.handleMentionTap { username in
            print("DEBUG: go to user profile : [\(username)]")
            self.delegate?.fetchUser(withUsername: username)
        }
        
        replyToUserLabel.handleMentionTap { mention in
            print("DEBUG: replying to metion @ : [\(mention)]")
        }
    }
    
}

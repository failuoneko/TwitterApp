//
//  PostTweetViewController.swift
//  TwitterApp
//
//  Created by L on 2021/10/9.
//

import UIKit
import ActiveLabel

class PostTweetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    private let config: PostTweetConfiguration
    private lazy var viewModel = PostTweetViewModel(config: config)
    
    private lazy var tweetReplyButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .customBlue
        button.setTitle("Tweet", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.snp.makeConstraints{ $0.width.equalTo(64) }
        button.snp.makeConstraints{ $0.height.equalTo(32) }
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(postTweet), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray
        imageView.snp.makeConstraints{ $0.size.equalTo(48) }
        imageView.layer.cornerRadius = 48 / 2
        return imageView
    }()
    
    private let replyUserLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .customBlue
//        label.text = "replying to @testuser"
        return label
    }()
    
    private let captionTextView = InputTextView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureMention()
        
//        switch config {
//        case .tweet:
//            print("DEBUG: cofing:tweet")
//        case .reply(let tweet):
//            print("DEBUG: Replying to \(tweet.caption)")
//        }
        
    }
    
    init(user: User, config: PostTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func postTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.postTweet(caption: caption, type: config) { error, ref in
            if let error = error {
                print("DEBUG: Failed to post tweet:\(error.localizedDescription)")
                return
            }
            
            // 確認是否在回覆的推文中。
            if case .reply(let tweet) = self.config {
                NotificationService.shared.postNotification(type: .reply, tweet: tweet)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    
    // MARK: - Helpers
    
    func configureUI() {
        configureNavigationBar()
        view.backgroundColor = .white
        
        let imageCaptionStack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageCaptionStack.axis = .horizontal
        imageCaptionStack.spacing = 10
        imageCaptionStack.alignment = .leading
        
        let stack = UIStackView(arrangedSubviews: [replyUserLabel, imageCaptionStack])
        stack.axis = .vertical
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
        tweetReplyButton.setTitle(viewModel.tweetReplyButtonTitle, for: .normal)
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        
        replyUserLabel.isHidden = !viewModel.shouldShowReplyLabel
        guard let replyUserText = viewModel.replyUserText else { return }
        replyUserLabel.text = replyUserText
        
    }
    
    func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetReplyButton)
    }
    
    // MARK: - Helpers

    func configureMention() {
        replyUserLabel.handleMentionTap { mention in
            print("DEBUG: metioned user : [\(mention)]")
        }
    }
    
}

//
//  PostTweetViewController.swift
//  TwitterApp
//
//  Created by L on 2021/10/9.
//

import UIKit

class PostTweetViewController: UIViewController {
    
    // MARK: - Properties
    
    private let user: User
    
    private lazy var tweetButton: UIButton = {
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
    
    private let captionTextView = CaptionTextView()
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func postTweet() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.postTweet(caption: caption) { error, ref in
            if let error = error {
                print("DEBUG: Failed to post tweet:\(error.localizedDescription)")
                return
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
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 10
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.left.right.equalToSuperview().inset(20)
        }
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
    }
    
    func configureNavigationBar() {
        view.backgroundColor = .white
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: tweetButton)
    }
}

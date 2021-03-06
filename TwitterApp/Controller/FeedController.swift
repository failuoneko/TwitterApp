//
//  FeedController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit
import Kingfisher

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configureSmallProfileImageView()
        }
    }
    
    private var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
    private lazy var smallProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints{ $0.size.equalTo(30) }
        let tap = UITapGestureRecognizer(target: self, action: #selector(smallProfileImageViewTapped))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tap)
        return imageView
    }()
    
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchTweets()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchTweets() {
        
        collectionView.refreshControl?.beginRefreshing()
        TweetService.shared.fetchTweets { tweets in
            // 顯示貼文，最新推文顯示在最上面。
            self.tweets = tweets.sorted{ $0.timestamp ?? Date() > $1.timestamp ?? Date() }
            // 查看User是否有按讚。
            self.checkIsUserLikedTweets()
            
            self.collectionView.refreshControl?.endRefreshing()

        }
    }
    
    // 依序檢查，有按讚才繼續往下執行。
    func checkIsUserLikedTweets() {
        self.tweets.forEach { tweet in
            TweetService.shared.checkIsUserLikedTweet(tweet) { didLike in
                guard didLike == true else { return }
                
                if let index = self.tweets.firstIndex(where: { $0.tweetID == tweet.tweetID }) {
                    self.tweets[index].didLike = true
                }
            }
        }
    }
    
    // MARK: - Selectors
    
    @objc func handelRefresh() {
        fetchTweets()
    }
    
    @objc func smallProfileImageViewTapped() {
        print("DEBUG: smallProfileImageViewTapped")
        guard let user = user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.id)
        collectionView.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo"))
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints{ $0.size.equalTo(44) }
        navigationItem.titleView = imageView
        
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
    }
    
    func configureSmallProfileImageView() {
        guard let user = user else { return }
        smallProfileImageView.kf.setImage(with: user.profileImageUrl)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: smallProfileImageView)
    }
    
}

// MARK: - UICollectionViewControllerDelegate/DataSource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.id, for: indexPath) as! TweetCell
        cell.delegate = self
        cell.tweet = tweets[indexPath.row]
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: tweets[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.cellSize(forWith: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 100)
    }
}

// MARK: - TweetCellDelegate

extension FeedController: TweetCellDelegate {
    
    func profileImageViewTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else { return }
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func replyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        let controller = PostTweetViewController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    func likeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else { return }
        TweetService.shared.likeTweet(tweet: tweet) { error, ref in
            cell.tweet?.didLike.toggle()
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.likes = likes
            
            // 只有點讚時才發送通知。
            guard !tweet.didLike else { return }
            NotificationService.shared.postNotification(user: tweet.user, tweetID: tweet.tweetID, type: .like)
        }
    }
    
    func fetchUser(_ cell: TweetCell, withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            print("DEBUG: user : [\(user.username)]")
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

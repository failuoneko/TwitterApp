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
    
    private let smallProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        imageView.snp.makeConstraints{ $0.size.equalTo(30) }
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
        TweetService.shared.fetchTweets { tweets in
            self.tweets = tweets
        }
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
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
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
        
        return CGSize(width: view.frame.width, height: height + 80)
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
    
}

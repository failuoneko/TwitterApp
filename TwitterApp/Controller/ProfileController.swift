//
//  ProfileController.swift
//  TwitterApp
//
//  Created by L on 2021/10/12.
//

import UIKit
import Firebase

class ProfileController: UICollectionViewController {
    
    // MARK: - Properties
    
    private var user: User
    
    private var pageSelector: PageSelectorViewOptions = .tweets {
        didSet { collectionView.reloadData() }
    }
    
    private var tweets: [Tweet] = []
    private var likedTweets: [Tweet] = []
    private var replies: [Tweet] = []
    
    // Tweets / Tweets&Replies / Likes 頁面切換。
    private var currentData: [Tweet] {
        switch pageSelector {
        case .tweets:
            return tweets
        case .replies:
            return replies
        case .likes:
            return likedTweets
        }
    }
    
    //    private var tweets: [Tweet] = [] {
    //        didSet { collectionView.reloadData() }
    //    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUserTweets()
        fetchLikedTweets()
        fetchUserReplies()
        checkIsfollowed()
        fetchUserFollowStatus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    
    
    
    // MARK: - API
    
    // 初始Tweets頁面。
    func fetchUserTweets() {
        TweetService.shared.fetchUserTweets(forUser: user) { tweets in
            self.tweets = tweets.sorted{ $0.timestamp ?? Date() > $1.timestamp ?? Date() }
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets.sorted{ $0.timestamp ?? Date() > $1.timestamp ?? Date() }
        }
    }
    
    func fetchUserReplies() {
        TweetService.shared.fetchUserReplies(forUSer: user) { tweets in
            self.replies = tweets.sorted{ $0.timestamp ?? Date() > $1.timestamp ?? Date() }
        }
    }
    
    func checkIsfollowed() {
        UserService.shared.checkIsFollowed(uid: user.uid) { isFollowed in
            self.user.isUserFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserFollowStatus() {
        UserService.shared.fetchUserFollow(uid: user.uid) { follow in
            self.user.follow = follow
            self.collectionView.reloadData()
            print("DEBUG: followers: \(follow.followers)")
            print("DEBUG: following: \(follow.following)")
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.id)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.id)
        
        // 滑到底部(增加底部空間 = tabBar高度)
        guard let tabHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tabHeight
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        var height: CGFloat = 330
        
        if user.bio != nil {
            height += 50
        }
        
        return CGSize(width: view.frame.width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let viewModel = TweetViewModel(tweet: currentData[indexPath.row])
        let height = viewModel.cellSize(forWith: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 100)
        
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentData.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.id, for: indexPath) as! TweetCell
        cell.tweet = currentData[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension ProfileController {
    // 設置 reuse 的 section 的 header 或 footer
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ProfileHeader.id, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = TweetController(tweet: currentData[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    func didSelect(page: PageSelectorViewOptions) {
        print("DEBUG did select page [\(page.description)] in profileController")
        self.pageSelector = page
    }
    
    func dismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    func editProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrenUser {
//            print("DEBUG: show edit profile controller")
            let controller = EditProfileController(user: user)
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: true, completion: nil)
            return
        }
        
        if user.isUserFollowed {
            // 已追蹤時取消追蹤。
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                self.user.isUserFollowed = false
                self.collectionView.reloadData()
                //                header.editProfileFollowButton.setTitle("Follow", for: .normal)
            }
        } else {
            // 未追蹤時追蹤。
            UserService.shared.followUser(uid: user.uid) { error, ref in
                self.user.isUserFollowed = true
                self.collectionView.reloadData()
                //                header.editProfileFollowButton.setTitle("Following", for: .normal)
                
                #warning("被追蹤時收到通知")
                NotificationService.shared.postNotification(user: self.user, type: .follow)
                
            }
        }
        
        func dismissal() {
            navigationController?.popViewController(animated: true)
            
        }
    }
}

// MARK: - EditProfileControllerDelegate

extension ProfileController: EditProfileControllerDelegate {
    
    func controller(_ controller: EditProfileController, handleUpdate user: User) {
        controller.dismiss(animated: true, completion: nil)
        self.user = user
        self.collectionView.reloadData()
    }
    
    func logout() {
        do {
            print("DEBUG: log out")
            try Auth.auth().signOut()
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Error log out..:\(error.localizedDescription)")
        }
    }
}

// MARK: - TweetCellDelegate

extension ProfileController: TweetCellDelegate {
    
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


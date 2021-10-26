//
//  ProfileController.swift
//  TwitterApp
//
//  Created by L on 2021/10/12.
//

import UIKit

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
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func fetchLikedTweets() {
        TweetService.shared.fetchLikes(forUser: user) { tweets in
            self.likedTweets = tweets
        }
    }
    
    func fetchUserReplies() {
        TweetService.shared.fetchUserReplies(forUSer: user) { tweets in
            self.replies = tweets
//            self.replies.forEach { reply in
//                print("DEBUG: replying to [\(reply.replyingToUser)]")
//            }
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
        
        return CGSize(width: view.frame.width, height: 350)
        
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
}

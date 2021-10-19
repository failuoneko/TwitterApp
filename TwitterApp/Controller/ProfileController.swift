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
    
    private var tweets: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }
    
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
        checkIsfollowed()
        fetchUserStats()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    // MARK: - Selectors
    
    
    
    
    // MARK: - API
    
    func fetchUserTweets() {
        TweetService.shared.fetchUserTweets(forUser: user) { tweets in
            self.tweets = tweets
        }
    }
    
    func checkIsfollowed() {
        UserService.shared.checkIsFollowed(uid: user.uid) { isFollowed in
            self.user.isUserFollowed = isFollowed
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            self.user.stats = stats
            self.collectionView.reloadData()
            print("DEBUG: followers: \(stats.followers)")
            print("DEBUG: following: \(stats.following)")
        }
    }
    
    
    // MARK: - Helpers
    
    func configureUI() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.id)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: ProfileHeader.id)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension ProfileController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 350)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 150)
        
    }
}

// MARK: - UICollectionViewDataSource

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.id, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
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
}

// MARK: - ProfileHeaderDelegate

extension ProfileController: ProfileHeaderDelegate {
    
    func dismissal() {
        navigationController?.popViewController(animated: true)
    }
    
    func editProfileFollow(_ header: ProfileHeader) {
        
        if user.isCurrenUser {
            print("DEBUG: show edit profile controller")
            return
        }
        
                
        if user.isUserFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                self.user.isUserFollowed = false
                self.collectionView.reloadData()
//                header.editProfileFollowButton.setTitle("Follow", for: .normal)
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                self.user.isUserFollowed = true
                self.collectionView.reloadData()
//                header.editProfileFollowButton.setTitle("Following", for: .normal)

            }
        }
    }
    
}

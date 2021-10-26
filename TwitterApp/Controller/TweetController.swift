//
//  TweetController.swift
//  TwitterApp
//
//  Created by L on 2021/10/16.
//

import UIKit

class TweetController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let tweet: Tweet
    private var actionSheetAlert: ActionSheetAlert!
    private var replies: [Tweet] = [] {
        didSet { collectionView.reloadData() }
    }


    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
//        self.actionSheetAlert = ActionSheetAlert(user: tweet.user)
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchReplies()
//        print("DEBUG: tweet caption is \(tweet.caption)")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.barStyle = .black
    }

    // MARK: - Selectors


    // MARK: - API
    
    func fetchReplies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { replies in
            self.replies = replies
        }
    }

    
    // MARK: - Helpers

    func configureUI() {
        collectionView.backgroundColor = .white
        
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.id)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: TweetHeader.id)
//        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: TweetCell.id)
    }
    
    fileprivate func showActionSheetMethod(forUser user: User) {
        actionSheetAlert = ActionSheetAlert(user: user)
        actionSheetAlert.delegate = self
        actionSheetAlert.showAlert()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension TweetController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let height = viewModel.cellSize(forWith: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 230)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
        
    }
}

// MARK: - UICollectionViewDataSource

extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TweetCell.id, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension TweetController {
    // 設置 reuse 的 section 的 header 或 footer
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TweetHeader.id, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

extension TweetController: TweetHeaderDelegate {
    
    func showActionSheet() {
        if tweet.user.isCurrenUser {
            showActionSheetMethod(forUser: tweet.user)
        } else {
            UserService.shared.checkIsFollowed(uid: tweet.user.uid) { isfollowed in
                var user = self.tweet.user
                user.isUserFollowed = isfollowed
                self.showActionSheetMethod(forUser: user)
            }
        }
    }
    
    func fetchUser(withUsername username: String) {
        UserService.shared.fetchUser(withUsername: username) { user in
            print("DEBUG: user : [\(user.username)]")
            let controller = ProfileController(user: user)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}

// MARK: - ActionSheetAlertDelegate

extension TweetController: ActionSheetAlertDelegate {
    func didSelect(option: ActionSheetOptions) {
//        print("DEBUG: option in controller : \(option.description)")
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { error, ref in
                print("DEBUG: Did follow user :\(user.username)")
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                print("DEBUG: Did unfollow user :\(user.username)")
            }
        case .report:
            print("DEBUG: Report tweet")
        case .delete:
            print("DEBUG: Delete tweet")
        }
    }
}

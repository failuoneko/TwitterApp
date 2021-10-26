//
//  NotificationController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

class NotificationController: UITableViewController {
    
    // MARK: - Properties
    
    private var notifications: [Notification] = [] {
        didSet { tableView.reloadData() }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNotifications()
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Selectors
    
    @objc func handelRefresh() {
        //        print("do refresh")
        //        refreshControl?.endRefreshing()
        fetchNotifications()
    }
    
    
    // MARK: - API
    
    func fetchNotifications() {
        refreshControl?.beginRefreshing()
        
        NotificationService.shared.fetchNotifications { notifications in
            
            self.refreshControl?.endRefreshing()
            
            self.notifications = notifications
            self.checkIsUserFollowed(noifications: notifications)
        }
    }
    
    func checkIsUserFollowed(noifications: [Notification]) {
        // 判斷通知是否為空。
        guard !notifications.isEmpty else {
            notificationsAlert()
            return }
        
        // 類型為follow才執行。
        notifications.forEach { notification in
            guard case .follow = notification.type else { return }
            let user = notification.user
            
            UserService.shared.checkIsFollowed(uid: user.uid) { isFollowed in
                if let index = self.notifications.firstIndex(where: { $0.user.uid == notification.user.uid }) {
                    self.notifications[index].user.isUserFollowed = isFollowed
                }
            }
        }
    }
    
    fileprivate func notificationsAlert() {
        let alert = UIAlertController(title: "", message: "No Notifications", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Notification"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: NotificationCell.id)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(handelRefresh), for: .valueChanged)
    }
}

// MARK: - UITableViewDelegate

extension NotificationController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let notification = notifications[indexPath.row]
        guard let tweetID = notification.tweetID else { return }
        
        TweetService.shared.fetchOneTweet(withTweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}


// MARK: - UITableViewDataSource

extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NotificationCell.id, for: indexPath) as! NotificationCell
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
}

// MARK: - NotificationCellDelegate

extension NotificationController: NotificationCellDelegate {
    func tapFollow(_ cell: NotificationCell) {
        
        guard let user = cell.notification?.user else { return }
        
        if user.isUserFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error, ref in
                cell.notification?.user.isUserFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error, ref in
                cell.notification?.user.isUserFollowed = true
            }
        }
    }
    
    func tapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else { return }
        
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
    
}

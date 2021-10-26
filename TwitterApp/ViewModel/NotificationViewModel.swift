//
//  NotificationViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/20.
//

import UIKit

struct NotificationViewModel {
    
    // MARK: - Properties

    private let notification: Notification
    private let type: NotificationType
    private let user: User
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated //以空白分隔，顯示時分秒的縮寫。
        return formatter.string(from: notification.timestamp ?? Date(), to: Date()) ?? "1m"
    }
    
    var notificationMessage: String {
        switch type {
        
        case .follow:
            return " started following you"
        case .like:
            return " liked your tweet"
        case .reply:
            return " replied to your tweet"
        case .retweet:
            return " retweeted your tweet"
        case .mention:
            return " mentioned you in a tweet"
        }
    }
    
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow // 對方如果按追蹤，通知就顯示follow，其餘隱藏。
    }
    
    var followButtonText: String {
        return user.isUserFollowed ? "Following" : "Follow"
    }
    
    var notificationText: NSAttributedString? {
        //        guard let timestamp = timestampString else { return nil }
        let usernameAttributedtitle = NSAttributedString(string: user.username,
                                                      attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let notificationMessageAttributedtitle = NSAttributedString(string: notificationMessage,
                                                       attributes: [.font: UIFont.systemFont(ofSize: 14)])
        let timestampAttributedtitle = NSAttributedString(string: " \(timestampString)",
                                                      attributes: [.foregroundColor: UIColor.lightGray,
                                                                   .font: UIFont.systemFont(ofSize: 14)])
        let attributedText = NSMutableAttributedString()
        attributedText.append(usernameAttributedtitle)
        attributedText.append(notificationMessageAttributedtitle)
        attributedText.append(timestampAttributedtitle)
        
        return attributedText
        
    }
    
    // MARK: - Lifecycle
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}

//
//  TwitterNotificationService.swift
//  TwitterApp
//
//  Created by L on 2021/10/19.
//

import Firebase

struct NotificationService {
    
    static let shared = NotificationService()
    
    func postNotification(type: NotificationType, tweet: Tweet? = nil, user: User? = nil) {
        //        print("DEBUG: type is :\(type)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["uid": uid,
                                     "timestamp": Int(NSDate().timeIntervalSince1970),
                                     "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            // 到該user創建通知的結構，並更新資料。
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        } else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
        }
        
    }
}

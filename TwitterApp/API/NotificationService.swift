//
//  NotificationService.swift
//  TwitterApp
//
//  Created by L on 2021/10/19.
//

import Firebase

struct NotificationService {
    
    static let shared = NotificationService()
    
    func postNotification(user: User, tweetID: String? = nil, type: NotificationType) {
        //        print("DEBUG: type is :\(type)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["uid": uid,
                                     "timestamp": Int(NSDate().timeIntervalSince1970),
                                     "type": type.rawValue]
        
        if let tweetID = tweetID {
            values["tweetID"] = tweetID
        }
        REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values)
    }
    
    func fetchNotifications(completion: @escaping([Notification]) -> Void) {
        let notifications: [Notification] = []
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // 判斷通知是否為空，為空時回傳空的Array。
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                completion(notifications)
            } else {
                self.fetchNotifications(uid: uid, completion: completion)
            }
        }
    }
    
    fileprivate func fetchNotifications(uid: String, completion: @escaping([Notification]) -> Void) {
        var notifications: [Notification] = []
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = Notification(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
    
}

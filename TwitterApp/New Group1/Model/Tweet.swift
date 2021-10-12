//
//  Tweet.swift
//  TwitterApp
//
//  Created by L on 2021/10/11.
//

import Foundation

struct Tweet {
    let user: User
    let tweetID: String
    let uid: String
    let caption: String
    let likes: Int
    let retweets: Int
    var timestamp: Date?
    
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.user = user
        self.tweetID = tweetID
        
        self.uid = dictionary["uid"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweets = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}

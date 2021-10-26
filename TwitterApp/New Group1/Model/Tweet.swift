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
    let caption: String
    var likes: Int
    let retweets: Int
    var timestamp: Date?
    var didLike = false
    var replyingToUser: String?
    
    var isReply: Bool { return replyingToUser != nil}
    
    
    init(user: User, tweetID: String, dictionary: [String: Any]) {
        self.user = user
        self.tweetID = tweetID
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweets = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
        if let replyingToUser = dictionary["replyingToUser"] as? String {
            self.replyingToUser = replyingToUser
        }
    }
}

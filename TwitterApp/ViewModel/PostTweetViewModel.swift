//
//  PostTweetViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/17.
//

import UIKit

enum PostTweetConfiguration {
    case tweet
    case reply(Tweet)
}

struct PostTweetViewModel {
    let tweetReplyButtonTitle: String
    let placeholderText: String
    var shouldShowReplyLabel: Bool
    var replyUserText: String?
    
    init(config: PostTweetConfiguration) {
        switch config {
        case .tweet:
            tweetReplyButtonTitle = "Tweet"
            placeholderText = "What's happening?"
            shouldShowReplyLabel = false
        case .reply(let tweet):
            tweetReplyButtonTitle = "Reply"
            placeholderText = "Tweet your reply"
            shouldShowReplyLabel = true
            replyUserText = "Replying to @\(tweet.user.username)"
        }
    }
}

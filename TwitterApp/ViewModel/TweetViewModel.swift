//
//  TweetViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/12.
//

import UIKit

struct TweetViewModel {
    
    let tweet: Tweet
    let user: User
    
    var profileImageUrl: URL? {
        return tweet.user.profileImageUrl
    }
    
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated //以空白分隔，顯示時分秒的縮寫。
        return formatter.string(from: tweet.timestamp ?? Date(), to: Date()) ?? "1m"
    }
    
    var userInfoText: NSAttributedString {
        let firstAttributedtitle = NSAttributedString(string: user.fullname,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 16)])
        let secondAttributedtitle = NSAttributedString(string: " @\(user.username)",
                                                       attributes: [.foregroundColor: UIColor.lightGray,
                                                                    .font: UIFont.boldSystemFont(ofSize: 16)])
        let timestamptitle = NSAttributedString(string: "・\(timestamp)",
                                                attributes: [.foregroundColor: UIColor.lightGray,
                                                             .font: UIFont.boldSystemFont(ofSize: 16)])
        let attributedText = NSMutableAttributedString()
        attributedText.append(firstAttributedtitle)
        attributedText.append(secondAttributedtitle)
        attributedText.append(timestamptitle)
        
        return attributedText
        
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}

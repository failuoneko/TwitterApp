//
//  TweetViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/12.
//

import UIKit

struct TweetViewModel {
    
    // MARK: - Properties
    
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
    
    var usernameText: String {
        return "@\(user.username)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp ?? Date())
    }
    
    var retweetAttributedTextString: NSAttributedString? {
        return attributedText(withValue: tweet.retweets, text: "Retweets")
    }
    
    var likeAttributedTextString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let firstAttributedtitle = NSAttributedString(string: user.fullname,
                                                      attributes: [.font: UIFont.systemFont(ofSize: 14)])
        let secondAttributedtitle = NSAttributedString(string: " @\(user.username)",
                                                       attributes: [.foregroundColor: UIColor.lightGray,
                                                                    .font: UIFont.boldSystemFont(ofSize: 14)])
        let timestamptitle = NSAttributedString(string: "・\(timestamp)",
                                                attributes: [.foregroundColor: UIColor.lightGray,
                                                             .font: UIFont.boldSystemFont(ofSize: 14)])
        let attributedText = NSMutableAttributedString()
        attributedText.append(firstAttributedtitle)
        attributedText.append(secondAttributedtitle)
        attributedText.append(timestamptitle)
        
        return attributedText
        
    }
    
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "heart.fill" : "heart"
        return UIImage(systemName: imageName)!
    }
    
    var shouldHideReplyToUserLabel: Bool {
        return !tweet.isReply // 回覆(Reply)時不隱藏。
    }
    
    var replyText: String? {
        guard let username = tweet.replyingToUser else { return nil }
        return "→ replying to @\(username)"
    }
    
    // MARK: - Lifecycle
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    // MARK: - Helpers
    
    func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let firstAttributedtitle = NSAttributedString(string: "\(value)",
                                                      attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        let secondAttributedtitle = NSAttributedString(string: " \(text)",
                                                       attributes: [.foregroundColor: UIColor.lightGray,
                                                                    .font: UIFont.systemFont(ofSize: 14)])
        let attributedText = NSMutableAttributedString()
        attributedText.append(firstAttributedtitle)
        attributedText.append(secondAttributedtitle)
        
        return attributedText
    }
    
    // 獲取高度
    func cellSize(forWith width: CGFloat) -> CGSize {
        let measurementLabel = UILabel()
        measurementLabel.text = tweet.caption
        measurementLabel.numberOfLines = 0
        measurementLabel.lineBreakMode = .byWordWrapping // 換行時以單詞為斷點
        measurementLabel.snp.makeConstraints{ $0.width.equalTo(width) }
        
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize) // 盡可能大
//        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)

    }

}

//
//  ProfileHeaderViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/13.
//

import UIKit

enum PagSelectorViewOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description:String {
        switch self {
        case .tweets:
            return "Tweets"
        case .replies:
            return "Tweets & Replies"
        case .likes:
            return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    
    private let user: User
    
    let usernameText: String
    
    var followingString: NSAttributedString? {
        return attributedText(withValue: user.stats?.following ?? 0, text: "following")
    }
    var followersString: NSAttributedString? {
        return attributedText(withValue: user.stats?.followers ?? 0, text: "followers")
    }
    
    var editProfileFollowButtonTitle: String {
        if user.isCurrenUser {
            return "Edit Profile"
        }
        
        // 沒被追蹤，且非當前用戶。
        if !user.isUserFollowed && !user.isCurrenUser {
            return "Follow"
        }
        
        if user.isUserFollowed {
            return "Following"
        }
        
        return "Loading..."
    }
    
    init(user: User) {
        self.user = user
        self.usernameText = "@" + user.username
    }
    
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
}

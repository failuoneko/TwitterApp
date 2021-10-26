//
//  PageSelectorViewOptions.swift
//  TwitterApp
//
//  Created by L on 2021/10/21.
//

import UIKit

enum PageSelectorViewOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
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

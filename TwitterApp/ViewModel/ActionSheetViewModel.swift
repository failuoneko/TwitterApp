//
//  ActionSheetViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/19.
//

import UIKit

struct ActionSheetViewModel {
    
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results: [ActionSheetOptions] = []
        
        if user.isCurrenUser {
            results.append(.delete)
        } else {
            // 被追隨時顯示取消追隨，否則顯示追隨。
            let followOption: ActionSheetOptions = user.isUserFollowed ? .unfollow(user) : .follow(user)
            results.append(followOption)
        }
        
        results.append(.report)
        
        return results
    }
    
    
    init(user: User) {
        self.user = user
    }
}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.username)"
        case .unfollow(let user):
            return "Unfollow @\(user.username)"
        case .report:
            return "Report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
}

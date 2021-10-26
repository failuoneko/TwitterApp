//
//  EditProfileViewModel.swift
//  TwitterApp
//
//  Created by L on 2021/10/25.
//

import UIKit

enum EditProfileViewOptions: Int, CaseIterable {
    case fullname
    case username
    case bio
    
    var description: String {
        switch self {
        case .fullname:
            return "Fullname"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    
    private let user: User
    let option: EditProfileViewOptions
    
    var shouldHideTextField: Bool{
        return option == .bio
    }
    
    var shouldHideTextView: Bool{
        return option != .bio
    }
    
    var shouldHidePlaceholderLabel: Bool {
        return user.bio != ""
    }
    
    var titleText: String {
        return option.description
    }
    
    var optionValue: String? {
        switch option {
        case .fullname:
            return user.fullname
        case .username:
            return user.username
        case .bio:
            return user.bio
        }
    }
    
    init(user: User, option: EditProfileViewOptions) {
        self.user = user
        self.option = option
    }
    
}

//
//  User.swift
//  TwitterApp
//
//  Created by L on 2021/10/6.
//

import Foundation
import Firebase

struct User {
    let uid: String
    var profileImageUrl: URL?
    let email: String
    var fullname: String
    var username: String
    var isUserFollowed = false
    var follow: UserFollow?
    var bio : String?
    
    var isCurrenUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }

        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

struct UserFollow {
    var followers: Int
    var following: Int
}

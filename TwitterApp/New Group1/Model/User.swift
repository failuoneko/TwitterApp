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
    let fullname: String
    let username: String
    
    var isCurrenUser: Bool {
        return Auth.auth().currentUser?.uid == uid
    }
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
//        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        if let profileImageUrlString = dictionary["profileImageUrl"] as? String {
            guard let url = URL(string: profileImageUrlString) else { return }
            self.profileImageUrl = url
        }
    }
}

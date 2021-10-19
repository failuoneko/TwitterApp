//
//  TwitterNotificationService.swift
//  TwitterApp
//
//  Created by L on 2021/10/19.
//

import Foundation

struct NotificationService {
    static let shared = NotificationService()
    
    func postNotification(type: NotificationType) {
        print("DEBUG: type is :\(type)")
    }
}

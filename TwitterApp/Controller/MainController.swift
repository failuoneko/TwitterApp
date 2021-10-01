//
//  MainController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        
    }
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureViewControllers() {
        
        let feed = FeedController()
        let feedNav = configureNavigationController(image: UIImage(systemName: "house"), rootViewcontroller: feed)
        
        let explore = ExploreController()
        let exploreNav = configureNavigationController(image: UIImage(systemName: "magnifyingglass"), rootViewcontroller: explore)

        let notification = NotificationController()
        let notificationNav = configureNavigationController(image: UIImage(systemName: "bell"), rootViewcontroller: notification)

        let conversations = ConversationsController()
        let conversationsNav = configureNavigationController(image: UIImage(systemName: "envelope"), rootViewcontroller: conversations)

        conversations.tabBarItem.image = UIImage(systemName: "envelope")
        
        viewControllers = [feedNav, exploreNav, notificationNav, conversationsNav]
    }
    
    func configureNavigationController(image: UIImage?, rootViewcontroller: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewcontroller)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
}


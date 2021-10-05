//
//  MainController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit
import SnapKit

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        let configuration = UIImage.SymbolConfiguration(pointSize: 25)
        button.setImage(UIImage(systemName: "text.badge.plus", withConfiguration: configuration), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .customBlue
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViewControllers()
        configureUI()
        
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(60)
        }
        actionButton.layer.cornerRadius = 60 / 2
    }
    
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


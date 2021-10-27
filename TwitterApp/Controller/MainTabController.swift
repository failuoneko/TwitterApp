//
//  MainTabController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit
import SnapKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedController else { return }
            feed.user = user
        }
    }
    
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
//        logOut()
        view.backgroundColor = .customBlue
        authUser()
        
    }
    
    // MARK: - API
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authUser() {
        if Auth.auth().currentUser == nil {
            presentLoginScreen()
            print("DEBUG: is not logged in")
        } else {
            configureViewControllers()
            configureUI()
            fetchUser()
            print("DEBUG: is logged in")
        }
    }
    
    // MARK: - Selectors
    
    @objc func actionButtonTapped() {
        guard let user = user else { return }
        let nav = UINavigationController(rootViewController: PostTweetViewController(user: user, config: .tweet))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(70)
            make.right.equalToSuperview().inset(20)
            make.size.equalTo(60)
            actionButton.layer.cornerRadius = 60 / 2
        }
    }
    
    func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    func configureViewControllers() {
        
        let feed = FeedController(collectionViewLayout: UICollectionViewFlowLayout())
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


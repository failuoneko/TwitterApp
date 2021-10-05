//
//  FeedController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

class FeedController: UIViewController {
    
    // MARK: - Properties
    

    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        let imageView = UIImageView(image: UIImage(named: "twitter_logo"))
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }
}


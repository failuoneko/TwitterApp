//
//  ExploreController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

class ExploreController: UIViewController {
    
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
        navigationItem.title = "Explore"
    }
}

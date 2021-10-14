//
//  ExploreController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

class ExploreController: UITableViewController {
    
    // MARK: - Properties
    
    private var users: [User] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var filterUsers: [User] = [] {
        didSet { tableView.reloadData() }
    }
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    private let searchController = UISearchController(searchResultsController: nil)

    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
                
        configureUI()
        configureSearchController()
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.shared.fetchUsers { users in
                self.users = users
        }
    }
    
    
    // MARK: - Selectors
    
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
        
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.id)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false // 是否模糊
        searchController.hidesNavigationBarDuringPresentation = false // 是否隱藏導航欄
        searchController.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false // 是否跟隨view滑動
        
//        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
//            textField.textColor = .systemPurple
//            textField.backgroundColor = .white
//        }
    }
}

// MARK: - ExploreControllerDelegate/ExploreControllerDatasource

extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchMode ? filterUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.id, for: indexPath) as! UserCell
        let user = isSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        cell.user = user
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filterUsers[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}


// MARK: - UISearchResultsUpdating

// 更新搜尋結果
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterUsers = users.filter({ user in
            return user.fullname.contains(searchText) || user.username.contains(searchText)
        })
        self.tableView.reloadData()
    }
}

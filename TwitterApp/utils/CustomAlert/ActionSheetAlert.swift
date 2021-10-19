//
//  ActionSheetAlert.swift
//  TwitterApp
//
//  Created by L on 2021/10/18.
//

import UIKit

protocol ActionSheetAlertDelegate: AnyObject {
    func didSelect(option: ActionSheetOptions)
}

class ActionSheetAlert: NSObject {
    // MARK: - Properties

    private var tableViewHight: CGFloat?
    private let user: User
    private let tableView = UITableView()
    private var window: UIWindow?
    private lazy var viewModel = ActionSheetViewModel(user: user)
    weak var delegate: ActionSheetAlertDelegate?
    
    private lazy var blackView: UIView = {
        let view = UIView()
        view.alpha = 0
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        // 點擊blackView後dismiss
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissal))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    private lazy var footerView: UIView = {
        let view = UIView()
        view.addSubview(cancelButton)
        cancelButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.left.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            cancelButton.layer.cornerRadius = 50 / 2
        }
        return view
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = .systemGroupedBackground
        button.addTarget(self, action: #selector(dismissal), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init()
        
        configureTableView()
        
    }

    // MARK: - Selectors
    
    @objc func dismissal() {
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.tableView.frame.origin.y += 300
        }
    }



    // MARK: - Helpers

    func showTableView(_ shoukdShow: Bool) {
        guard let window = window else { return }
        guard let height = tableViewHight else { return }
        let y = shoukdShow ? window.frame.height - height : window.frame.height
        tableView.frame.origin.y = y
    }
    
    func showAlert() {
//        print("DEBUG: show action sheet for user\(user.username)")
        
        guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
        self.window = window
        
        window.addSubview(blackView)
        blackView.frame = window.frame
        
        window.addSubview(tableView)
        let height = CGFloat(viewModel.options.count * 60) + 100
        self.tableViewHight = height
        tableView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
        
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 1
            self.showTableView(true)
//            self.tableView.frame.origin.y -= height
        }
        
    }
    
    func configureTableView() {
        tableView.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.layer.cornerRadius = 5
        tableView.isScrollEnabled = false
        
        tableView.register(ActionSheetCell.self, forCellReuseIdentifier: ActionSheetCell.id)
    }
}

// MARK: - UITableViewDataSource

extension ActionSheetAlert: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ActionSheetCell.id, for: indexPath) as! ActionSheetCell
        cell.option = viewModel.options[indexPath.row]
        return cell
    }
}

// MARK: - UITableViewDelegate

extension ActionSheetAlert: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = viewModel.options[indexPath.row]
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            self.showTableView(false)
        } completion: { _ in
            self.delegate?.didSelect(option: option) // 關閉動畫跑完後，執行delegate。
        }
    }
}

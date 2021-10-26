//
//  EditProfileCell.swift
//  TwitterApp
//
//  Created by L on 2021/10/25.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    
    var viewModel: EditProfileViewModel? {
        didSet { configure() }
    }
    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
//        label.text = "TEST Title"
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .customBlue
        textField.addTarget(self, action: #selector(updateUserInfo), for: .editingDidEnd)
        textField.text = "TEST Username"
        return textField
    }()
    
    let bioTextView: InputTextView = {
        let textView = InputTextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .customBlue
        textView.placeholderLabel.text = "Bio"
        return textView
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Selectors
    
    @objc func updateUserInfo() {
        delegate?.updateUserInfo(self)
    }
    
    
    // MARK: - Helpers
    
    func configure() {
        guard let viewModel = viewModel else { return }
        infoTextField.isHidden = viewModel.shouldHideTextField
        bioTextView.isHidden = viewModel.shouldHideTextView
        
        titleLable.text = viewModel.titleText
        infoTextField.text = viewModel.optionValue
        bioTextView.placeholderLabel.isHidden = viewModel.shouldHidePlaceholderLabel
        bioTextView.text = viewModel.optionValue
    }
    
    func configureUI() {
        backgroundColor = .white
        selectionStyle = .none
        
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.top.equalToSuperview().inset(12)
            make.left.equalToSuperview().inset(20)
        }

        contentView.addSubview(infoTextField)
        infoTextField.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
            make.left.equalTo(titleLable.snp.right).inset(-12)
            make.right.equalToSuperview().inset(8)
        }

        contentView.addSubview(bioTextView)
        bioTextView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(4)
            make.bottom.equalToSuperview()
            make.left.equalTo(titleLable.snp.right).inset(-8)
            make.right.equalToSuperview().inset(8)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInfo), name: UITextView.textDidEndEditingNotification, object: nil)
        
    }
}

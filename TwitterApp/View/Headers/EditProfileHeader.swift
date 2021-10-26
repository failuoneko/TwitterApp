//
//  EditProfileHeader.swift
//  TwitterApp
//
//  Created by L on 2021/10/24.
//

import UIKit

protocol EditProfileHeaderDelegate: AnyObject {
    func changeProfilePhotoButtonTapped()
}

class EditProfileHeader: UIView {
    
    // MARK: - Properties
    
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        return imageView
    }()
    
    private let changeProfilePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Change Profile Photo", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(changeProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Selectors
    
    @objc func changeProfilePhoto() {
        delegate?.changeProfilePhotoButtonTapped()
    }
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
        backgroundColor = .customBlue
        
        addSubview(profileImageView)
        profileImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-20)
            make.size.equalTo(120)
            profileImageView.layer.cornerRadius = 120 / 2
        }
        
        addSubview(changeProfilePhotoButton)
        changeProfilePhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).inset(-10)
        }
        
        profileImageView.kf.setImage(with: user.profileImageUrl)
        
    }
    
}

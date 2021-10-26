//
//  EditProfileController.swift
//  TwitterApp
//
//  Created by L on 2021/10/24.
//

import UIKit

protocol EditProfileControllerDelegate: AnyObject {
    func controller(_ controller: EditProfileController, handleUpdate user: User)
    func logout()
}

class EditProfileController: UITableViewController {
    
    // MARK: - Properties
    
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private lazy var footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    private var isUserInfoChanged = false
    
    weak var delegate: EditProfileControllerDelegate?
    
    private var isImageChanged: Bool {
        return selectedImage != nil
    }
    
    private var selectedImage: UIImage? {
        didSet { headerView.profileImageView.image = selectedImage }
    }
    
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureImagePicker()
        configureNavigationBar()
        configureTableView()
        
    }
    
    // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        view.endEditing(true)
        guard isImageChanged || isUserInfoChanged else { return }
        updateUserData()
        //        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - API
    
    func updateUserData() {
        
        if isImageChanged && !isUserInfoChanged {
            print("DEBUG: changed image and no data")
            updateProfileImage()
        }
        
        if !isImageChanged && isUserInfoChanged {
            UserService.shared.saveUserData(user: user) { error, ref in
                print("DEBUG: changed image and no image")
                self.delegate?.controller(self, handleUpdate: self.user)
            }
        }
        
        if isImageChanged && isUserInfoChanged {
            print("DEBUG: changed both")
            UserService.shared.saveUserData(user: user) { error, ref in
                self.updateProfileImage()
            }
        }
    }
    
    func updateProfileImage() {
        guard let image = selectedImage else { return }
        
        UserService.shared.updateProfileImage(image: image) { profileImageUrl in
            self.user.profileImageUrl = profileImageUrl
            self.delegate?.controller(self, handleUpdate: self.user)
        }
    }
    
    
    // MARK: - Helpers
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func configureUI() {
        tableView.backgroundColor = .white
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = .customBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false // 消除navigation bar半透明設定
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        //        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    // MARK: - configureTableView
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        tableView.isScrollEnabled = false
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 200)
        
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        
        headerView.delegate = self
        footerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: EditProfileCell.id)
    }
}

// MARK: - UITableViewDataSource

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileViewOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileCell.id, for: indexPath) as! EditProfileCell
        
        cell.delegate = self
        guard let option = EditProfileViewOptions(rawValue: indexPath.row) else { return cell }
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileViewOptions(rawValue: indexPath.row) else { return 0 }
        return option == .bio ? 120 : 50
    }
}

// MARK: - EditProfileHeaderDelegate

extension EditProfileController: EditProfileHeaderDelegate {
    func changeProfilePhotoButtonTapped() {
        print("DEBUG: change photo button tapped")
        present(imagePicker, animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        //        self.addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.selectedImage = image
        //
        //        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        //        addPhotoButton.layer.borderWidth = 3
        //        addPhotoButton.layer.cornerRadius = CGFloat(addPhotoButtonSize / 2)
        //        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        //        addPhotoButton.imageView?.clipsToBounds = true
        print("DEBUG: update profile photo")
        dismiss(animated: true, completion: nil)
        
    }
}

// MARK: - EditProfileCellDelegate

extension EditProfileController: EditProfileCellDelegate {
    func updateUserInfo(_ cell: EditProfileCell) {
        
        isUserInfoChanged = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        
        guard let viewModel = cell.viewModel else { return }
        switch viewModel.option {
        case .fullname:
            guard let fullname = cell.infoTextField.text else { return }
            user.fullname = fullname
        case .username:
            guard let username = cell.infoTextField.text else { return }
            user.username = username
        case .bio:
            user.bio = cell.bioTextView.text
        }
        print("DEBUG: fullname = [\(user.fullname)]")
        print("DEBUG: username = [\(user.username)]")
        print("DEBUG: bio = [\(user.bio)]")
        
    }
}

// MARK: - EditProfileFooterDelegate

extension EditProfileController: EditProfileFooterDelegate {
    
    func logout() {
        let alert = UIAlertController(title: nil, message: "Are you sure to log out?", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.logout()
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

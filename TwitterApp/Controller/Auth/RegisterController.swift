//
//  RegisterController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit
import Firebase
import FirebaseDatabase

class RegisterController: UIViewController {
    // MARK: - Properties
    
    let imagePickerController = UIImagePickerController()
    
    private let addPhotoButtonSize = 150
    private var profileImage: UIImage?

    private let addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: "person.crop.circle.badge.plus"), for: .normal)
        button.tintColor = .white
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(addProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var emailContainerView: UIView = {
        let image = UIImage(systemName: "envelope")
        let view = Utilities().inputContainerView(withImage: image, textField: emailTextField)
        view.tintColor = .white
        return view
    }()
    
    private lazy var passwordContainerView: UIView = {
        let image = UIImage(systemName: "lock")
        let view = Utilities().inputContainerView(withImage: image, textField: passwordTextField)
        view.tintColor = .white
        return view
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let image = UIImage(systemName: "person")
        let view = Utilities().inputContainerView(withImage: image, textField: fullnameTextField)
        view.tintColor = .white
        return view
    }()
    
    private lazy var usernameContainerView: UIView = {
        let image = UIImage(systemName: "person.crop.circle")
        let view = Utilities().inputContainerView(withImage: image, textField: usernameTextField)
        view.tintColor = .white
        return view
    }()
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let fullnameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Full Name")
        return textField
    }()
    
    private let usernameTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Username")
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("sign Up", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.customBlue, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.snp.makeConstraints{ $0.height.equalTo(50) }
        button.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        return button
    }()
    
    private let alreadyHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Already have a account? ", "Log In")
        button.addTarget(self, action: #selector(showLoginPage), for: .touchUpInside)
        return button
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }

    // MARK: - Selectors
    
    @objc func addProfilePhoto() {
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func signUp() {
        
        guard let profileImage = profileImage else {
            print("DEBUG: no image")
            return }
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullname = fullnameTextField.text else { return }
        guard let username = usernameTextField.text else { return }
        
        let creadentials = RegisterCredentials(profileImage: profileImage,
                                               email: email,
                                               password: password,
                                               fullname: fullname,
                                               username: username)
        AuthService.shared.creatUser(credentials: creadentials) { error, ref in
            print("DEBUG: sign up suceessful")
            print("DEBUG: update user interface")
            
            guard let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow }) else { return }
            guard let mainTab = window.rootViewController as? MainTabController else { return }
            mainTab.authUser()
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
    }

    @objc func showLoginPage() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Helpers

    func configureUI() {
        view.backgroundColor = .customBlue
        
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        view.addSubview(addPhotoButton)
        addPhotoButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.size.equalTo(addPhotoButtonSize)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView,
                                                   usernameContainerView,
                                                   signUpButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(addPhotoButton.snp.bottom).inset(-30)
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.right.equalTo(view).inset(30)
        }
        
    }
}

// MARK: - UIImagePickerControllerDelegate

extension RegisterController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else { return }
        self.addPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        self.profileImage = image
        
        addPhotoButton.layer.borderColor = UIColor.white.cgColor
        addPhotoButton.layer.borderWidth = 3
        addPhotoButton.layer.cornerRadius = CGFloat(addPhotoButtonSize / 2)
        addPhotoButton.imageView?.contentMode = .scaleAspectFill
        addPhotoButton.imageView?.clipsToBounds = true
        
        dismiss(animated: true, completion: nil)
        
    }
}

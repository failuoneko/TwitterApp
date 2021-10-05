//
//  LoginController.swift
//  TwitterApp
//
//  Created by L on 2021/10/1.
//

import UIKit

class LoginController: UIViewController {
    // MARK: - Properties
    
    private let twitterlogoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = #imageLiteral(resourceName: "TwitterLogo")
        return imageView
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
    
    private let emailTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Email")
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = Utilities().textField(withPlaceholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.backgroundColor = .white
        button.setTitleColor(.customBlue, for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.snp.makeConstraints{ $0.height.equalTo(50) }
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = Utilities().attributedButton("Dont't have a account? ", "Sign Up")
        button.addTarget(self, action: #selector(showSignUpPage), for: .touchUpInside)
        return button
    }()


    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }

    // MARK: - Selectors

    @objc func login() {
        print("LOGIN")
    }
    
    @objc func showSignUpPage() {
        let controller = RegisterController()
        navigationController?.pushViewController(controller, animated: true)
    }

    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .customBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        view.addSubview(twitterlogoImageView)
        twitterlogoImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.size.equalTo(150)
        }
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   loginButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        
        view.addSubview(stack)
        stack.snp.makeConstraints { make in
            make.top.equalTo(twitterlogoImageView.snp.bottom)
            make.left.right.equalToSuperview().inset(30)
        }
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.left.right.equalTo(view).inset(30)
        }
        
    }
    
}

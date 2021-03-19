//
//  AutorizationViewController.swift
//  Course2FinalTask
//
//  Created by Ivan on 28.12.2020.
//  Copyright © 2020 e-Legion. All rights reserved.
//

import UIKit

final class AutorizationViewController: UIViewController {
    
    //    MARK: - Private Properties
    private var appDelegate = AppDelegate.shared
    private var apiManager = APIInstagramManager()
    private let keychain: KeychainProtocol = KeychainManager()
    private lazy var alert = AlertViewController(view: self)
    private lazy var block = BlockViewController(view: view)
    
    private lazy var loginTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Login"
        textField.textContentType = .username
        textField.keyboardType = .emailAddress
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 14)
        textField.autocapitalizationType = .none
        textField.returnKeyType = .next
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(inputText), for: .editingChanged)
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Password"
        textField.textContentType = .password
        textField.keyboardType = .asciiCapable
        textField.borderStyle = .roundedRect
        textField.font = .systemFont(ofSize: 14)
        textField.isSecureTextEntry = true
        textField.autocapitalizationType = .none
        textField.returnKeyType = .send
        textField.enablesReturnKeyAutomatically = true
        textField.delegate = self
        textField.addTarget(self, action: #selector(inputText), for: .editingChanged)
        return textField
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.setTitle("Sign in", for: .normal)
        button.alpha = 0.3
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.white, for: .normal)
        button.isEnabled = false
        button.addTarget(self, action: #selector(signinPressed), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycles Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        guard let token = keychain.readToken(userName: "user") else { return }
        block.startAnimating()
        APIInstagramManager.token = token
        block.stopAnimating()
        presentTabBarController()
    }
    
    //    MARK: - Private Methods
    private func createUI() {
        view.backgroundColor = .white
        let elements = [loginTextField, passwordTextField, loginButton]
        
        elements.forEach { (element) in
            view.addSubview(element)
        }
        
        let constraints = [loginTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
                           loginTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
                           loginTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
                           loginTextField.heightAnchor.constraint(equalToConstant: 40),
                           
                           passwordTextField.topAnchor.constraint(equalTo: loginTextField.bottomAnchor, constant: 8),
                           passwordTextField.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
                           passwordTextField.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
                           passwordTextField.heightAnchor.constraint(equalToConstant: 40),
                           
                           loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 100),
                           loginButton.leadingAnchor.constraint(equalTo: loginTextField.leadingAnchor),
                           loginButton.trailingAnchor.constraint(equalTo: loginTextField.trailingAnchor),
                           loginButton.heightAnchor.constraint(equalToConstant: 50)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func presentTabBarController() {
        let storyboard = UIStoryboard(name: AppDelegate.storyboardName, bundle: nil)
        
        guard let tabBar = storyboard.instantiateViewController(withIdentifier: "TabBar") as? TabBarController else { return }
        
        appDelegate.window?.rootViewController = tabBar
    }
    
    @objc private func inputText() {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return }
        
        loginButton.isEnabled = !login.isEmpty && !password.isEmpty
        loginButton.alpha = loginButton.isEnabled ? 1 : 0.3
    }
    
    @objc private func signinPressed() {
        guard let login = loginTextField.text,
              let password = passwordTextField.text else { return }
        
        apiManager.signin(login: login, password: password) { [weak self] (result) in
            
            switch result {
            case .success(let token):
                
                self?.keychain.saveToken(token: token.token, userName: login)
                
                APIInstagramManager.token = token.token
                
                self?.presentTabBarController()
                
            case.failure(let error):
                self?.alert.createAlert(error: error)
            }
        }
    }
}

// MARK: - Text Field Delegate
extension AutorizationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == loginTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            signinPressed()
        }
        
        return true
    }
}

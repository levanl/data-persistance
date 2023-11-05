//
//  LoginViewController.swift
//  DataPersistance
//
//  Created by Levan Loladze on 05.11.23.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Properties
    
    private let welcomeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Notes App"
        label.font = UIFont.systemFont(ofSize: 30)
        return label
    }()
    
    private let loginStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 20
        return stackView
    }()
    
    private let loginTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username or Email"
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "password"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return textField
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("LOGIN", for: .normal)
        button.backgroundColor = .red
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        setupUI()
    }
    
    
    private func setupUI() {
        setupLabel()
        setupLoginStackView()
    }
    
    // MARK: - Login Button Action

    @objc private func loginButtonTapped() {
        
        guard let username = loginTextField.text, !username.isEmpty else {
            showAlert(message: "Please enter a username")
            return
        }
        guard let password = passwordTextField.text, !password.isEmpty else {
            showAlert(message: "Please enter a password")
            return
        }
        
        do {
            if let savedPasswordData = KeychainManager.get(service: "newNoteApp", account: "levaniko123"),
               let savedPassword = String(data: savedPasswordData, encoding: .utf8),
               savedPassword == password {
                let isFirstTimeLogin = !UserDefaults.standard.bool(forKey: "hasLoggedInBefore")
                UserDefaults.standard.set(true, forKey: "hasLoggedInBefore")
                if isFirstTimeLogin {
                    showAlert(message: "Welcome! Thank you for logging in for the first time.")
                    UserDefaults.standard.set(false, forKey: "hasLoggedInBefore")
                }
                
            } else {
                save()
            }
        } catch {
            print(error)
            showAlert(message: "Error")
        }
        
        let noteListViewController = NoteListViewController()
        navigationController?.pushViewController(noteListViewController, animated: true)
        
        
    }
    
    private func getPassword() {
        guard let data = KeychainManager.get(
            service: "newNoteApp", account: "levaniko123"
        ) else {
            print("failed to read")
            return
        }
        
        let password = String(decoding: data, as: UTF8.self)
        print(password)
    }
    
    private func save() {
        do {
            try KeychainManager.save(service: "newNoteApp", account: "levaniko123", username: loginTextField.text ?? "" ,password: passwordTextField.text?.data(using: .utf8) ?? Data())
        }
        catch {
            print(error)
        }
        
    }
    
    // MARK: - UI Setup

    func setupLabel() {
        view.addSubview(welcomeLabel)
        
        NSLayoutConstraint.activate([
            welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            welcomeLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60)
        ])
    }
    
    func setupLoginStackView() {
        view.addSubview(loginStackView)
        loginStackView.addArrangedSubview(loginTextField)
        loginStackView.addArrangedSubview(passwordTextField)
        loginStackView.addArrangedSubview(loginButton)
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        
        NSLayoutConstraint.activate([
            loginStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            loginStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60),
            loginStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60)
        ])
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "message", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
}

// MARK: - Keychain Setup

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }

    // MARK: - Save Function

    static func save(
        service: String,
        account: String,
        username: String,
        password: Data
    ) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecAttrLabel as String: username as AnyObject,
            kSecValueData as String: password as AnyObject,
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            print("successfull entry")
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        
        print("saved")
    }
    
    // MARK: - Get Function
    
    static func get(
        service: String,
        account: String
    ) -> Data? {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
            kSecReturnData as String: kCFBooleanTrue,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        
        print(status)
        
        return result as? Data
    }
    
    
}



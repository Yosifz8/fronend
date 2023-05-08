//
//  LoginViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 07/05/2023.
//

import UIKit

protocol LoginProtocol {
    func didFinishLoginProcess()
}

final class LoginViewController: UIViewController {
    
    private let padding: CGFloat = 40
    private let delegate: LoginProtocol
    
    init(delegate: LoginProtocol) {
        self.delegate = delegate
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let loginTextField = {
        let textField = UITextField()
        
        textField.placeholder = "Username"
        
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configueView()
    }
    
    private func configueView() {
        let label = {
            let label = UILabel()
            
            label.text = "Enter username:"
            label.textAlignment = .left
            
            return label
        }()
        
        let loginButton = {
            let btn = UIButton(type: .system)
            
            btn.setTitle("Login", for: .normal)
            btn.titleLabel?.font =  .systemFont(ofSize: 20)
            btn.setTitleColor(.white, for: .normal)
            btn.backgroundColor = UIColor(red: 37/255, green: 211/255, blue: 102/255, alpha: 1.0)
            
            btn.layer.cornerRadius = 5
            
            btn.addTarget(self, action: #selector(didPressLoginButton), for: .touchUpInside)
            
            return btn
        }()
        
        view.backgroundColor = .white
        view.addSubviews([label, loginTextField, loginButton])
        
        label.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding))
        
        loginTextField.anchor(top: label.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: padding, left: padding, bottom: 0, right: padding))
        
        loginButton.anchor(top: loginTextField.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: padding, left: padding, bottom: padding, right: padding), size: .init(width: view.width - (padding*2), height: 50))
    }
    
    private func setButtons() {
        
    }
    
    private func showEmptyUsername() {
        let alert = UIAlertController(title: "Error", message: "Please enter a username", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension LoginViewController {
    @objc private func didPressLoginButton() {
        guard let username = loginTextField.text, !username.isEmpty else {
            showEmptyUsername()
            
            return
        }
        
        LoginService.shared.username = username
        delegate.didFinishLoginProcess()
    }
}

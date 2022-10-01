//
//  ViewController.swift
//  Bankey
//
//  Created by W Lawless on 9/19/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Props
    
    let labelStack = UIStackView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    let loginView = LoginView()
    let loginButton = UIButton(type: .system)
    let errorMessageLabel = UILabel()
    
    weak var delegate: LoginViewControllerDelegate? //weak reference to app delegate 

    var username: String? {
        return loginView.usernameTextField.text
    }
    
    var password: String? {
        loginView.passwordTextField.text
    }
    
    // MARK: - Animation Props
    
    var leadingEdgeOnScreen: CGFloat = 16
    var leadingEdgeOffScreen: CGFloat = -1000
    
    var titleLeadingAnchor: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        loginButton.configuration?.showsActivityIndicator = false
    }

}

// MARK: - Style and Layout

extension LoginViewController {
    
    private func style() {
        
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.axis = .vertical
        labelStack.spacing = 8
        labelStack.alpha = 0
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        titleLabel.textAlignment = .center
        titleLabel.adjustsFontForContentSizeCategory = true
        titleLabel.text = "Bankey"
        
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = UIFont.preferredFont(forTextStyle: .title3)
        subtitleLabel.textAlignment = .center
        subtitleLabel.numberOfLines = 0
        subtitleLabel.text = "Your premium mobile banking app!"
        
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        loginButton.configuration = .filled()
        loginButton.configuration?.imagePadding = 8
        loginButton.setTitle("Log In", for: [])
        loginButton.addTarget(self, action: #selector(loginTapped), for: .primaryActionTriggered)
        
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.textColor = .systemRed
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.text = "Username / Password cannot be blank."
        errorMessageLabel.isHidden = true
        
    }
    
    private func layout() {
        labelStack.addArrangedSubview(titleLabel)
        labelStack.addArrangedSubview(subtitleLabel)
        view.addSubview(labelStack)
        view.addSubview(loginView)
        view.addSubview(loginButton)
        view.addSubview(errorMessageLabel)
        
        // Title Labels
        NSLayoutConstraint.activate([
            labelStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: labelStack.trailingAnchor, multiplier: 1)
        ])
        
        titleLeadingAnchor = labelStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: leadingEdgeOffScreen)
        titleLeadingAnchor?.isActive = true
        
        
        // Login View
        NSLayoutConstraint.activate([
            loginView.topAnchor.constraint(equalToSystemSpacingBelow: labelStack.bottomAnchor, multiplier: 4),
            loginView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: loginView.trailingAnchor, multiplier: 1)
        ])
        
        // Button
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalToSystemSpacingBelow: loginView.bottomAnchor, multiplier: 2),
            loginButton.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            loginButton.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
        
        // Error Tooltip
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: loginButton.bottomAnchor, multiplier: 2),
            errorMessageLabel.leadingAnchor.constraint(equalTo: loginView.leadingAnchor),
            errorMessageLabel.trailingAnchor.constraint(equalTo: loginView.trailingAnchor)
        ])
     
    }
}


// MARK: - Button Actions

extension LoginViewController {

    @objc func loginTapped(sender: UIButton) {
        errorMessageLabel.isHidden = true
        login()
    }
    
    private func login(){
        guard let username = username, let password = password else {
            assertionFailure("Username and password should not be nil")
            return
        }
        
//        if username.isEmpty || password.isEmpty {
//            configureView(withMessage: "Username / Password cannot be blank.")
//            return
//        }
        
        if username == "" && password == "" {
            loginButton.configuration?.showsActivityIndicator = true
            delegate?.didLogin()
        } else {
            configureView(withMessage: "Incorrect username / password")
        }
    }

    private func configureView(withMessage message: String) {
        errorMessageLabel.isHidden = false
        errorMessageLabel.text = message
        shakeButton()
    }
    
    private func shakeButton() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0, 10, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 0.4

        animation.isAdditive = true
        loginButton.layer.add(animation, forKey: "shake")
    }
}


// MARK: - Protocol Abstractions

protocol LoginViewControllerDelegate: AnyObject {
    func didLogin()
}

protocol LogoutDelegate: AnyObject {
    func didLogout()
}

// MARK: - Animations

extension LoginViewController {
    private func animate() {
        let animator1 = UIViewPropertyAnimator(duration: 1.25, curve: .easeInOut) {
            self.titleLeadingAnchor?.constant = self.leadingEdgeOnScreen
            self.view.layoutIfNeeded()
        }
        animator1.startAnimation()
        
        let animator2 = UIViewPropertyAnimator(duration: 0.5, curve: .easeIn) {
            self.labelStack.alpha = 1
            self.view.layoutIfNeeded()
        }
        animator2.startAnimation(afterDelay: 0.75)
    }
}

//
//  ViewController.swift
//  passwordReset
//
//  Created by W Lawless on 10/3/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Components
    
    let containerStack = UIStackView()
    let passwordComponent = PasswordView(placeholderText: "New Password")
    let confirmPasswordComponent = PasswordView(placeholderText: "Confirm Password")
    let criteriaView = ValidationView()
    let resetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        layout()
    }

}

// MARK: - Validation Callbacks



// MARK: - AutoLayout

extension ViewController {
    private func setup() {
        
        dismissKeyboardGesture()
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        passwordComponent.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerStack.axis = .vertical
        containerStack.spacing = 8
        
        passwordComponent.delegate = self
        
        resetButton.configuration = .filled()
        resetButton.setTitle("Reset Password", for: [])
        resetButton.addTarget(self, action: #selector(resetBtn), for: .primaryActionTriggered)

    }
    
    private func layout() {
        
        containerStack.addArrangedSubview(passwordComponent)
        containerStack.addArrangedSubview(criteriaView)
        containerStack.addArrangedSubview(confirmPasswordComponent)
        containerStack.addArrangedSubview(resetButton)
        
        view.addSubview(containerStack)
        
        NSLayoutConstraint.activate([
            containerStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerStack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: containerStack.trailingAnchor, multiplier: 2)
        ])
    }
    
    @objc private func resetBtn() {
        print("btn pressed")
    }
    
    private func dismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc private func dismissKeyboardAction(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

//MARK: - Protocol Delegate

extension ViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordView) {
        if sender === passwordComponent {
            criteriaView.updateDisplay(sender.passwordField.text ?? "")
        }
    }
    func editingDidEnd(_ sender: PasswordView) {
        
    }
}

// MARK: - Password Validation Checks

struct PasswordCriteria {
    static func lengthCriteriaMet(_ text: String) -> Bool {
        text.count >= 8 && text.count <= 32
    }
    
    static func noWhitespace(_ text: String) -> Bool {
        text.rangeOfCharacter(from: NSCharacterSet.whitespaces) == nil
    }
    
    static func lengthAndNoWhitespaceMet (_ text: String) -> Bool {
        noWhitespace(text) && lengthCriteriaMet(text)
    }
    
    static func upperCaseMet (_ text: String) -> Bool {
        text.range(of: "[A-Z]+", options: .regularExpression) != nil
    }
    
    static func lowerCaseMet (_ text: String) -> Bool {
        text.range(of: "[a-z]+", options: .regularExpression) != nil
    }
    
    static func digitMet (_ text: String) -> Bool {
        text.range(of: "[0-9]+", options: .regularExpression) != nil
    }
    
    static func specialCharsMet (_ text: String) -> Bool {
        text.range(of: "[\\p{P}\\p{S}]+", options: .regularExpression) != nil
    }
}

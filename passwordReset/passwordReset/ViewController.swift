//
//  ViewController.swift
//  passwordReset
//
//  Created by W Lawless on 10/3/22.
//

import UIKit

class ViewController: UIViewController {

    // MARK: - Properties
    
    typealias CustomValidation = (_ textValue: String?) -> (Bool, String)?
    
    // MARK: - Components
    
    let containerStack = UIStackView()
    let passwordComponent = PasswordView(placeholderText: "New Password")
    let confirmPasswordComponent = PasswordView(placeholderText: "Confirm Password")
    let criteriaView = ValidationView()
    let resetButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupNewPassword()
        setupConfirmPassword()
        setupKeyboardHiding()
        layout()
    }

}

//MARK: - Setup

extension ViewController {
    private func setupNewPassword() {
        let newPasswordValidation: CustomValidation = { text in
            
            // Empty text
            guard let text = text, !text.isEmpty else {
                self.criteriaView.reset()
                return (false, "Enter your password")
            }
            
            //Criteria Met
            self.criteriaView.updateDisplay(text)
            if !self.criteriaView.validate(text) {
                return (false, "Your password must meet the requirements")
            }
            return (true, "")
        }
        
        passwordComponent.customValidation = newPasswordValidation
        passwordComponent.delegate = self
    }
    
    private func setupConfirmPassword() {
        let confirmPasswordValidation: CustomValidation = { text in
            guard let text = text, !text.isEmpty else {
                return (false, "Enter your password")
            }
            
            guard text == self.passwordComponent.text else {
                return (false, "Passwords do not match.")
            }
            
            return (true , "")
        }
        
        confirmPasswordComponent.customValidation = confirmPasswordValidation
        confirmPasswordComponent.delegate = self
    }
    
    private func setupKeyboardHiding() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - AutoLayout

extension ViewController {
    private func setup() {
        
        dismissKeyboardGesture()
        
        containerStack.translatesAutoresizingMaskIntoConstraints = false
        passwordComponent.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        
        containerStack.axis = .vertical
        containerStack.spacing = 8
                
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
    
}

// MARK: - Actions

extension ViewController {
    @objc func resetBtn(sender: UIButton) {
        view.endEditing(true)
        
        let isValidNewPassword = passwordComponent.validate()
        let isValidConfirmPassword = confirmPasswordComponent.validate()
        
        if isValidNewPassword && isValidConfirmPassword {
            showAlert(title: "Success", message: "You have successfully changed your password.")
        }
    }
    
    private func showAlert(title: String, message: String) {
         let alert =  UIAlertController(title: "", message: "", preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

         alert.title = title
         alert.message = message
         present(alert, animated: true, completion: nil)
     }
    
    private func dismissKeyboardGesture() {
        let dismissKeyboardTap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboardAction(_: )))
        view.addGestureRecognizer(dismissKeyboardTap)
    }
    
    @objc private func dismissKeyboardAction(_ recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

//MARK: - Password Component Delegate Methods

extension ViewController: PasswordTextFieldDelegate {
    func editingChanged(_ sender: PasswordView) {
        if sender === passwordComponent {
            criteriaView.updateDisplay(sender.passwordField.text ?? "")
        }
    }
    func editingDidEnd(_ sender: PasswordView) {
        if sender === passwordComponent {
            criteriaView.shouldResetCriteria = false
            _ = passwordComponent.validate()
        } else if sender === confirmPasswordComponent {
            _ = confirmPasswordComponent.validate()
        }
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


// MARK: - Keyboard
extension ViewController {
    @objc func keyboardWillShow(sender: NSNotification)  {
        guard let userInfo = sender.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
              let currentTextField = UIResponder.currentFirst() as? UITextField else { return }

//        print("foo - userInfo: \(userInfo)")
//        print("foo - keyboardFrame: \(keyboardFrame)")
//        print("foo - currentTextField: \(currentTextField)")
        
        // check if the top of the keyboard is above the bottom of the currently focused textbox
        let keyboardTopY = keyboardFrame.cgRectValue.origin.y
        let convertedTextFieldFrame = view.convert(currentTextField.frame, from: currentTextField.superview)
        let textFieldBottomY = convertedTextFieldFrame.origin.y + convertedTextFieldFrame.size.height

        // if textField bottom is below keyboard bottom - bump the frame up
        if textFieldBottomY > keyboardTopY {
            // adjust view up
            let textBoxY = convertedTextFieldFrame.origin.y
            let newFrameY = (textBoxY - keyboardTopY / 2) * -1
            view.frame.origin.y = newFrameY
        }

    }

    @objc func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }
}

extension UIResponder {

    private struct Static {
        static weak var responder: UIResponder?
    }

    /// Finds the current first responder
    /// - Returns: the current UIResponder if it exists
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder._trap), to: nil, from: nil, for: nil)
        return Static.responder
    }

    @objc private func _trap() {
        Static.responder = self
    }
}

// MARK: - Test Helper Methods
extension ViewController {
    var newPasswordText: String? {
        get { return passwordComponent.text }
        set { passwordComponent.text = newValue}
    }
    
    var confirmPasswordText: String? {
        get { return confirmPasswordComponent.text }
        set { confirmPasswordComponent.text = newValue}
    }
}

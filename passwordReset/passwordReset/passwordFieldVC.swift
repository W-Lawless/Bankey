//
//  ViewController.swift
//  passwordReset
//
//  Created by W Lawless on 10/3/22.
//

import UIKit

protocol PasswordTextFieldDelegate: AnyObject {
    func editingChanged(_ sender: PasswordView)
    func editingDidEnd(_ sender: PasswordView)
}

class PasswordView: UIView, UITextFieldDelegate {

    // MARK: - Components
    
    let passwordField = UITextField()
    var placeholderText: String
    let dividerView = UIView()
    let passwordLabel = UILabel()
    let lockIcon = UIImageView()
    let eyeButton = UIButton()
    
    weak var delegate: PasswordTextFieldDelegate?
    
    init(placeholderText: String) {
        self.placeholderText = placeholderText
        super.init(frame: .zero)
        setup()
        layout()
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is flipping a bitch")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 50)
    }

}

// MARK: - AutoLayout

extension PasswordView {
    private func setup() {
        
        passwordField.placeholder = placeholderText
        passwordField.isSecureTextEntry = true
        passwordField.delegate = self
        passwordField.keyboardType = .asciiCapable
        passwordField.attributedPlaceholder =
        NSAttributedString(string: placeholderText,
                           attributes: [NSAttributedString.Key.foregroundColor: UIColor.secondaryLabel])
        passwordField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)

        dividerView.backgroundColor = .separator
        
        passwordLabel.text = "Enter your password"
        passwordLabel.textColor = .systemRed
        passwordLabel.font = .preferredFont(forTextStyle: .footnote)
        passwordLabel.adjustsFontSizeToFitWidth = true
        passwordLabel.minimumScaleFactor = 0.8
        passwordLabel.isHidden = true
        
        let lockImage = UIImage(systemName: "lock.fill")
        lockIcon.image = lockImage
        
        let eyeImage = UIImage(systemName: "eye.circle")
        let eyeInverseImage = UIImage(systemName: "eye.slash.circle")
        eyeButton.setImage(eyeImage, for: .normal)
        eyeButton.setImage(eyeInverseImage, for: .selected)
        eyeButton.addTarget(self, action: #selector(togglePasswordView), for: .touchUpInside)
    }
    
    private func layout() {
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        lockIcon.translatesAutoresizingMaskIntoConstraints = false
        eyeButton.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(lockIcon)
        addSubview(passwordField)
        addSubview(eyeButton)
        addSubview(dividerView)
        addSubview(passwordLabel)
        
        NSLayoutConstraint.activate([
            lockIcon.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            lockIcon.leadingAnchor.constraint(equalTo: leadingAnchor),
            
            passwordField.topAnchor.constraint(equalTo: topAnchor),
            passwordField.leadingAnchor.constraint(equalToSystemSpacingAfter: lockIcon.trailingAnchor, multiplier: 1),

            eyeButton.centerYAnchor.constraint(equalTo: passwordField.centerYAnchor),
            eyeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: passwordField.trailingAnchor, multiplier: 1),
            eyeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            dividerView.topAnchor.constraint(equalToSystemSpacingBelow: passwordField.bottomAnchor, multiplier: 1),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
            dividerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            dividerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            passwordLabel.topAnchor.constraint(equalToSystemSpacingBelow: dividerView.bottomAnchor, multiplier: 1),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        lockIcon.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        passwordField.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
        eyeButton.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)

    }
}

// MARK: - Actions

extension PasswordView {
    @objc private func togglePasswordView() {
        passwordField.isSecureTextEntry.toggle()
        eyeButton.isSelected.toggle()
    }

    @objc func textFieldEditingChanged(_ sender: UITextField) {
        delegate?.editingChanged(self)
    }
}

// MARK: - UITextFieldDelegate
extension PasswordView {
    
    // return NO to disallow editing.
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    // return YES to allow editing to stop and to resign first responder status.
    // return NO to disallow the editing session to end
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    // if implemented, called in place of textFieldDidEndEditing: ?
    func textFieldDidEndEditing(_ textField: UITextField) {
        delegate?.editingDidEnd(self)
    }
    
    // detect - keypress
    // return NO to not change text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        ///        let word = textField.text ?? ""
        ///        let char = string
        ///       print("Default - shouldChangeCharactersIn: \(word) \(char)")
        return true
    }
    
    // called when 'clear' button pressed. return NO to ignore (no notifications)
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        return true
    }
    
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        delegate?.editingDidEnd(self)
        textField.endEditing(true) // resign first responder
        return true
    }
}

//
//  ValidationView.swift
//  passwordReset
//
//  Created by W Lawless on 10/4/22.
//

import Foundation
import UIKit

class ValidationView: UIView {
    
    //MARK: - Properties
    
    let stackView = UIStackView()

    let characterCountLabel = labelWithImage(labelText: "8-32 characters.")
    let toolTip = UILabel()
    let uppercaseCriteriaLabel = labelWithImage(labelText: "At least 1 uppercase character.")
    let lowercaseCriteriaLabel = labelWithImage(labelText: "3-4 lowercase characters.")
    let digitCriteriaLabel = labelWithImage(labelText: "At least 1 digit.")
    let specialCharCriteriaLabel = labelWithImage(labelText: "At least 1 special character (@!#$)")
    
    private var shouldResetCriteria: Bool = true
    
    // MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is flipping a bitch.")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 100, height:280)
    }
    
    
}

//: MARK: - Extensions

extension ValidationView {
    
    func style() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.backgroundColor = .secondarySystemBackground
        stackView.distribution = .equalCentering
        stackView.layer.cornerRadius = 16
        stackView.clipsToBounds = true
        
        toolTip.attributedText = makeToolTip()
        toolTip.font = .preferredFont(forTextStyle: .footnote)
        toolTip.numberOfLines = 0
        toolTip.lineBreakMode = .byWordWrapping

    }
    
    func layout() {
        stackView.addArrangedSubview(characterCountLabel)
        stackView.addArrangedSubview(toolTip)
        stackView.addArrangedSubview(uppercaseCriteriaLabel)
        stackView.addArrangedSubview(lowercaseCriteriaLabel)
        stackView.addArrangedSubview(digitCriteriaLabel)
        stackView.addArrangedSubview(specialCharCriteriaLabel)
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 2),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1),

//            toolTip.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 2),
            trailingAnchor.constraint(equalToSystemSpacingAfter: toolTip.trailingAnchor, multiplier: 1),
            heightAnchor.constraint(equalToConstant: 260)
        ])
    }
    
    func makeToolTip() -> NSAttributedString {
        var plainTextAttributes = [NSAttributedString.Key: AnyObject]()
        plainTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)
        plainTextAttributes[.foregroundColor] = UIColor.secondaryLabel
        
        var boldTextAttributes = [NSAttributedString.Key: AnyObject]()
        boldTextAttributes[.foregroundColor] = UIColor.label
        boldTextAttributes[.font] = UIFont.preferredFont(forTextStyle: .subheadline)

        let attrText = NSMutableAttributedString(string: "Use at least ", attributes: plainTextAttributes)
        attrText.append(NSAttributedString(string: "3 of these 4 ", attributes: boldTextAttributes))
        attrText.append(NSAttributedString(string: "criteria when setting your password:", attributes: plainTextAttributes))

        return attrText
    }
}


class labelWithImage: UIView {
    
    // MARK: - Properties
    
    var labelText: String?
    var isCriteriaMet: Bool = false {
        didSet {
            if isCriteriaMet {
                icon.image = check
            } else {
                icon.image = xmark
            }
        }
    }
    
    
    //MARK: - Components

    let check = UIImage(systemName: "checkmark.circle")?.withTintColor( .systemGreen, renderingMode: .alwaysOriginal)
    let xmark = UIImage(systemName: "xmark.circle")?.withTintColor(.systemRed, renderingMode: .alwaysOriginal)
    let circle = UIImage(systemName: "circle")
    
    let icon = UIImageView()
    let label = UILabel()
    
    init(labelText: String) {
        self.labelText = labelText
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is flipping a bitch")
    }
    
    private func setup() {
        label.translatesAutoresizingMaskIntoConstraints = false
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = labelText
        label.font = .preferredFont(forTextStyle: .footnote)
        
        icon.image = circle
        
        addSubview(icon)
        addSubview(label)
        
        NSLayoutConstraint.activate([
            icon.centerYAnchor.constraint(equalTo: centerYAnchor),
            icon.leadingAnchor.constraint(equalToSystemSpacingAfter: leadingAnchor, multiplier: 1),
            
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(equalToSystemSpacingAfter: icon.trailingAnchor, multiplier: 1),
            label.trailingAnchor.constraint(equalToSystemSpacingAfter: trailingAnchor, multiplier: 1),
            heightAnchor.constraint(equalToConstant: 24)
        ])
        
        icon.setContentHuggingPriority(UILayoutPriority.defaultHigh, for: .horizontal)
        label.setContentHuggingPriority(UILayoutPriority.defaultLow, for: .horizontal)
    }
    
    func reset() {
        isCriteriaMet = false
        icon.image = circle
    }
}


// MARK: - Actions

extension ValidationView {
    func updateDisplay(_ text: String) {
        let lengthAndNoWhitespaceMet = PasswordCriteria.lengthAndNoWhitespaceMet(text)
        let upperCaseMet = PasswordCriteria.upperCaseMet(text)
        let lowerCaseMet = PasswordCriteria.lowerCaseMet(text)
        let digitMet = PasswordCriteria.digitMet(text)
        let specialCharMet = PasswordCriteria.specialCharsMet(text)
        
        if shouldResetCriteria {
            lengthAndNoWhitespaceMet
            ? characterCountLabel.isCriteriaMet = true
            : characterCountLabel.reset()
            
            upperCaseMet
            ? uppercaseCriteriaLabel.isCriteriaMet = true
            : uppercaseCriteriaLabel.reset()
            
            lowerCaseMet
            ? lowercaseCriteriaLabel.isCriteriaMet = true
            : lowercaseCriteriaLabel.reset()
            
            digitMet
            ? digitCriteriaLabel.isCriteriaMet = true
            : digitCriteriaLabel.reset()
            
            specialCharMet
            ? specialCharCriteriaLabel.isCriteriaMet = true
            : specialCharCriteriaLabel.reset()
        }
    }
}

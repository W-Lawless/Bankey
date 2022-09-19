//
//  LoginView.swift
//  Bankey
//
//  Created by W Lawless on 9/19/22.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        style()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Rough View Dimensions
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
}

//: MARK: - Extensions
 
extension LoginView {
    
    func style() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func layout() { }
}

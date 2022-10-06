//
//  passwordResetTests.swift
//  passwordResetTests
//
//  Created by W Lawless on 10/6/22.
//

import XCTest

@testable import passwordReset

class passwordResetTests: XCTestCase {

    func testLong() throws {
        XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("123456789012345678901234567890123"))
    }
    
    func testShort() throws {
        XCTAssertFalse(PasswordCriteria.lengthCriteriaMet("1234567"))
    }
    
    func testValidShort() throws {
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678"))
    }

    func testValidLong() throws {
        XCTAssertTrue(PasswordCriteria.lengthCriteriaMet("12345678901234567890123456789012"))
    }
    
    func testSpaceMet() throws {
        XCTAssertTrue(PasswordCriteria.noWhitespace("abc"))
    }
    
    func testSpaceNotMet() throws {
        XCTAssertFalse(PasswordCriteria.noWhitespace("a bc"))
    }
    
    func testLengthAndNoSpaceMet() throws {
        XCTAssertTrue(PasswordCriteria.lengthAndNoWhitespaceMet("12345678"))
    }

    func testLengthAndNoSpaceNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lengthAndNoWhitespaceMet("1234567 8"))
    }
    
    func testUpperCaseMet() throws {
        XCTAssertTrue(PasswordCriteria.upperCaseMet("A"))
    }

    func testUpperCaseNotMet() throws {
        XCTAssertFalse(PasswordCriteria.upperCaseMet("a"))
    }

    func testLowerCaseMet() throws {
        XCTAssertTrue(PasswordCriteria.lowerCaseMet("a"))
    }

    func testLowerCaseNotMet() throws {
        XCTAssertFalse(PasswordCriteria.lowerCaseMet("A"))
    }

    func testDigitMet() throws {
        XCTAssertTrue(PasswordCriteria.digitMet("1"))
    }

    func testDigitNotMet() throws {
        XCTAssertFalse(PasswordCriteria.digitMet("a"))
    }
    
    func testSpecicalCharMet() throws {
        XCTAssertTrue(PasswordCriteria.specialCharsMet("@"))
    }

    func testSpecicalCharNotMet() throws {
        XCTAssertFalse(PasswordCriteria.specialCharsMet("a"))
    }

}


class PasswordStatusViewTests_ShowCheckmarkOrReset_When_Validation_Is_Inline: XCTestCase {

    var statusView: ValidationView!
    let validPassword = "12345678Aa!"
    let tooShort = "123Aa!"
    
    override func setUp() {
        super.setUp()
        statusView = ValidationView()
        statusView.shouldResetCriteria = true // inline
    }

    /*
     if shouldResetCriteria {
         // Inline validation (✅ or ⚪️)
     } else {
         ...
     }
     */

    func testValidPassword() throws {
        statusView.updateDisplay(validPassword)
        XCTAssertTrue(statusView.characterCountLabel.isCriteriaMet)
        XCTAssertTrue(statusView.characterCountLabel.isCheckMarkImage) // ✅
    }
    
    func testTooShort() throws {
        statusView.updateDisplay(tooShort)
        XCTAssertFalse(statusView.characterCountLabel.isCriteriaMet)
        XCTAssertTrue(statusView.characterCountLabel.isResetImage) // ⚪️
    }
}


class PasswordStatusViewTests_Validate_Three_of_Four: XCTestCase {

    var statusView: ValidationView!
    let twoOfFour = "12345678A"
    let threeOfFour = "12345678Aa"
    let fourOfFour = "12345678Aa!"

    // Verify is valid if three of four criteria met
    override func setUp() {
        super.setUp()
        statusView = ValidationView()
    }

    func testTwoOfFour() throws {
        XCTAssertFalse(statusView.validate(twoOfFour))
    }
    
    func testThreeOfFour() throws {
        XCTAssertTrue(statusView.validate(threeOfFour))
    }

    func testFourOfFour() throws {
        XCTAssertTrue(statusView.validate(fourOfFour))
    }
}

class ViewControllerTests_NewPassword_Validation: XCTestCase {

    var vc: ViewController!
    let validPassword = "12345678Aa!"
    let tooShort = "1234Aa!"
    
    override func setUp() {
        super.setUp()
        vc = ViewController()
    }

    /*
     Here we trigger those criteria blocks by entering text,
     clicking the reset password button, and then checking
     the error label text for the right message.
     */
    
    func testEmptyPassword() throws {
        vc.newPasswordText = ""
        vc.resetBtn(sender: UIButton())
        
        XCTAssertEqual(vc.passwordComponent.passwordLabel.text!, "Enter your password")
    }

    func testValidPassword() throws {
        vc.newPasswordText = validPassword
        vc.resetBtn(sender: UIButton())
        
        XCTAssertEqual(vc.passwordComponent.passwordLabel.text!, "")
    }
    
    func testPasswordsDoNotMatch() throws {
        vc.newPasswordText = validPassword
        vc.confirmPasswordText = tooShort
        vc.resetBtn(sender: UIButton())
        
        XCTAssertEqual(vc.confirmPasswordComponent.passwordLabel.text!, "Passwords do not match.")
    }

    func testPasswordsMatch() throws {
        vc.newPasswordText = validPassword
        vc.confirmPasswordText = validPassword
        vc.resetBtn(sender: UIButton())
        
        XCTAssertEqual(vc.confirmPasswordComponent.passwordLabel.text!, "")
    }
}

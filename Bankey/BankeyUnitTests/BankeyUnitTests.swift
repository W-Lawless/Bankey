//
//  BankeyUnitTests.swift
//  BankeyUnitTests
//
//  Created by W Lawless on 9/30/22.
//

import Foundation
import XCTest
@testable import Bankey

class CurrencyTest: XCTestCase {

    var formatter: CurrencyFormatter!
    
    override func setUp() {
        super.setUp()
        formatter = CurrencyFormatter()
    }
    
    func testBreakDollarsIntoCents() throws {
        let result = formatter.breakIntoDollarsAndCents(929466.23)
        XCTAssertEqual(result.0, "929,466")
        XCTAssertEqual(result.1, "23")
    }
    
    func testDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "$929,466.23")
    }
    
    func testZeroDollarsFormatted() throws {
        let result = formatter.dollarsFormatted(0.00)
        XCTAssertEqual(result, "$0.00")
    }
    
    func testDollarsFormattedWithLocale() throws {
        let locale = Locale.current
        let symbol = locale.currencySymbol!
        
        let result = formatter.dollarsFormatted(929466.23)
        XCTAssertEqual(result, "\(symbol)929,466.23")
    }
}

class ParseTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    func testCanParseProfile() throws {
        let json = """
        {
        "id": "1",
        "first_name": "Kevin",
        "last_name": "Flynn",
        }
        """
        
        let data = json.data(using: .utf8)!
        let result = try! JSONDecoder().decode(Profile.self, from: data)
        
        XCTAssertEqual(result.id, "1")
        XCTAssertEqual(result.firstName, "Kevin")
        XCTAssertEqual(result.lastName, "Flynn")
    }
    
    func testCanParseAccount() throws {
        let json = """
         [
           {
             "id": "1",
             "type": "Banking",
             "name": "Basic Savings",
             "amount": 929466.23,
             "createdDateTime" : "2010-06-21T15:29:32Z"
           },
           {
             "id": "2",
             "type": "Banking",
             "name": "No-Fee All-In Chequing",
             "amount": 17562.44,
             "createdDateTime" : "2011-06-21T15:29:32Z"
           },
          ]
        """
        
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        let result = try decoder.decode([Account].self, from: data)
        
        XCTAssertEqual(result.count, 2)
        
        let account1 = result[0]
        XCTAssertEqual(account1.id, "1")
        XCTAssertEqual(account1.type, .Banking)
        XCTAssertEqual(account1.name, "Basic Savings")
        XCTAssertEqual(account1.amount, 929466.23)
        XCTAssertEqual(account1.createdDateTime.monthDayYearString, "Jun 21, 2010")
    }
}


class AccountSummaryViewControllerTests: XCTestCase {
    var vc: AccountSummaryVC!
    var mockManager: MockNetworkManager!
    
    class MockNetworkManager: NetworkManageable {
        var profile: Profile?
        var account: Account?
        var error: NetworkError?
        
        func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile, NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            profile = Profile(id: "1", firstName: "FirstName", lastName: "LastName")
            completion(.success(profile!))
        }
        
        func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void) {
            if error != nil {
                completion(.failure(error!))
                return
            }
            account = Account(id: "1", type: .Banking, name: "Checking", amount: 100.17, createdDateTime: Date())
            completion(.success([account!]))
        }
    }
    
    override func setUp() {
        super.setUp()
        vc = AccountSummaryVC()
        mockManager = MockNetworkManager()
        vc.networkManager = mockManager
        // vc.loadViewIfNeeded()
    }
    
    func testTitleAndMessageForServerError() throws {
        let titleAndMessage = vc.configureAlertForTesting(for: .serverError)
        XCTAssertEqual("Server Error", titleAndMessage.0)
        XCTAssertEqual("We could not proccess your request.", titleAndMessage.1)
    }
    
    func testTitleAndMessageForNetworkError() throws {
        let titleAndMessage = vc.configureAlertForTesting(for: .decodingError)
        XCTAssertEqual("Network Error", titleAndMessage.0)
        XCTAssertEqual("Check your connection.", titleAndMessage.1)
    }
    
    func testAlertForSeverError() throws {
        mockManager.error = .serverError
        vc.forceFetchProfile()
        
        XCTAssertEqual(vc.errorAlert.title, "Server Error")
        XCTAssertEqual(vc.errorAlert.message, "We could not proccess your request.")
    }
    
    func testAlertForDecodingError() throws {
        mockManager.error = .decodingError
        vc.forceFetchProfile()
        
        XCTAssertEqual(vc.errorAlert.title, "Network Error")
        XCTAssertEqual(vc.errorAlert.message, "Check your connection.")
    }

}


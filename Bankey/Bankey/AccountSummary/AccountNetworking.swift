//
//  AccountNetworking.swift
//  Bankey
//
//  Created by W Lawless on 10/1/22.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case serverError
    case decodingError
}

struct Account: Codable {
    let id: String
    let type: AccountType
    let name: String
    let amount: Decimal
    let createdDateTime: Date
    
    static func makeSkeleton() -> Account {
        return Account(id: "1", type: .Banking, name: "Account Name", amount: 0.0, createdDateTime: Date())
    }
}

struct Profile: Codable {
    let id: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }
}

class NetworkManager: NetworkManageable {
    
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile,NetworkError>) -> Void) {
        let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)")!

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    completion(.failure(.serverError))
                    return
                }

                do {
                    let profile = try JSONDecoder().decode(Profile.self, from: data)
                    completion(.success(profile))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account],NetworkError>) -> Void) {
            let url = URL(string: "https://fierce-retreat-36855.herokuapp.com/bankey/profile/\(userId)/accounts")!

            URLSession.shared.dataTask(with: url) { data, response, error in
                DispatchQueue.main.async {
                    guard let data = data, error == nil else {
                        completion(.failure(.serverError))
                        return
                    }
                    
                    do {
                        let decoder = JSONDecoder()
                        decoder.dateDecodingStrategy = .iso8601
                        
                        let accounts = try decoder.decode([Account].self, from: data)
                        completion(.success(accounts))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }.resume()
        }
}

// MARK: - Unit Testing

protocol NetworkManageable: AnyObject {
    func fetchProfile(forUserId userId: String, completion: @escaping (Result<Profile,NetworkError>) -> Void)
    func fetchAccounts(forUserId userId: String, completion: @escaping (Result<[Account], NetworkError>) -> Void)
}

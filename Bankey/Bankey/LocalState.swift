//
//  LocatState.swift
//  Bankey
//
//  Created by W Lawless on 9/22/22.
//

import Foundation

public class LocalState {
    private enum Keys: String {
        case hasOnboarded
    }
    
    public static var hasOnboarded: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Keys.hasOnboarded.rawValue)
        }
        set(newValue) {
            UserDefaults.standard.set(newValue, forKey: Keys.hasOnboarded.rawValue)
            //UserDefaults.standard.synchronize() depecrated as of iOS 12
        }
    }
}

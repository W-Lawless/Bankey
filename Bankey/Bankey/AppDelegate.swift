//
//  AppDelegate.swift
//  Bankey
//
//  Created by W Lawless on 9/19/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    

    var window: UIWindow?
    let loginViewController = LoginViewController() //strong reference to login controller
    let onboardingContainerViewContoller = OnboardingContainerViewController()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        onboardingContainerViewContoller.delegate = self
//        window?.rootViewController = loginViewController
        window?.rootViewController = onboardingContainerViewContoller
        
        return true
    }

}

// MARK: - Delegation Protocols

extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        print("Did Login")
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        print("True")
    }
}

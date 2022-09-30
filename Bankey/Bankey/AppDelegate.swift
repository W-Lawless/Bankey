//
//  AppDelegate.swift
//  Bankey
//
//  Created by W Lawless on 9/19/22.
//

import UIKit

// MARK: - Constants

let appColor: UIColor = UIColor.systemTeal

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // MARK: - Properties

    var window: UIWindow?
    let loginViewController = LoginViewController()
    let onboardingContainerViewContoller = OnboardingContainerViewController()

    let mainVC = MainViewController()

    let accountVC = AccountSummaryVC()
    let defaults = UserDefaults.standard
    
    // MARK: - Initialization
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .systemBackground
        
        loginViewController.delegate = self
        onboardingContainerViewContoller.delegate = self
        
        
        mainVC.selectedIndex = 0
        mainVC.setStatusBar()
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().backgroundColor = appColor
        
        window?.rootViewController = mainVC
            
        return true
    }

}

// MARK: - Delegation Protocols

extension AppDelegate: LoginViewControllerDelegate {
    func didLogin() {
        if LocalState.hasOnboarded {
            setRootViewController(accountVC)
        } else {
            setRootViewController(onboardingContainerViewContoller)
        }
    }
}

extension AppDelegate: OnboardingContainerViewControllerDelegate {
    func didFinishOnboarding() {
        LocalState.hasOnboarded = true
        setRootViewController(mainVC)
    }
}

extension AppDelegate: LogoutDelegate {
    func didLogout() {
        setRootViewController(loginViewController)
    }
}

//MARK: - Transition Function

extension AppDelegate {
    func setRootViewController(_ vc: UIViewController, animated: Bool = true){
        guard animated, let window = self.window else {
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            return
        }
        
        window.rootViewController = vc
        window.makeKeyAndVisible()
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil   )
    }
}

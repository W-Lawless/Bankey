//
//  OnBoardingContainerViewController.swift
//  Bankey
//
//  Created by W Lawless on 9/20/22.
//

import UIKit

class OnboardingContainerViewController: UIViewController {

    let pageViewController: UIPageViewController
    var pages = [UIViewController]()
    var currentVC: UIViewController
    
    let closeButton = UIButton(type: .system)
    let backButton = UIButton(type: .system)
    let nextButton = UIButton(type: .system)
    let doneButton = UIButton(type: .system)
    
    weak var delegate: OnboardingContainerViewControllerDelegate?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        self.pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        let page1 = OnboardingViewController(heroImageName: "delorean", titleText: "Bankey is a clean & modern mobile banking application.")
        let page2 = OnboardingViewController(heroImageName: "world", titleText: "Engineered to make mobile banking easy for everyone.")
        let page3 = OnboardingViewController(heroImageName: "thumbs", titleText: "Highly rated by satisfied consumers!")
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        currentVC = pages.first!
        
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        style()
        layout()
        
        pageViewController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        currentVC = pages.first!
    }
    
    // Inherited by UIViewController, Required constructor for Storyboards
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Style & Layout

extension OnboardingContainerViewController {
    private func style() {
        view.backgroundColor = .systemGray

        addChild(pageViewController)
        view.addSubview(pageViewController.view)
        view.addSubview(closeButton)
        view.addSubview(backButton)
        view.addSubview(nextButton)
        view.addSubview(doneButton)
        
        pageViewController.didMove(toParent: self)

        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.setTitle("Close", for: [])
        closeButton.addTarget(self, action: #selector(closeTapped), for: .primaryActionTriggered)
        
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.setTitle("Back", for: [])
        backButton.addTarget(self, action: #selector(backTapped), for: .primaryActionTriggered)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.setTitle("Next", for: [])
        nextButton.addTarget(self, action: #selector(nextTapped), for: .primaryActionTriggered)
        
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.setTitle("Done", for: [])
        backButton.addTarget(self, action: #selector(doneTapped), for: .primaryActionTriggered)
        
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func layout(){
        
        // Page View
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: pageViewController.view.topAnchor),
            view.leadingAnchor.constraint(equalTo: pageViewController.view.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: pageViewController.view.trailingAnchor),
            view.bottomAnchor.constraint(equalTo: pageViewController.view.bottomAnchor),
        ])
        
        // Button
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            closeButton.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 2)
        ])
        
        NSLayoutConstraint.activate([
            backButton.bottomAnchor.constraint(equalToSystemSpacingBelow: pageViewController.view.bottomAnchor, multiplier: -40),
            backButton.leadingAnchor.constraint(equalToSystemSpacingAfter: pageViewController.view.leadingAnchor, multiplier: 1)
        ])
        
        NSLayoutConstraint.activate([
            nextButton.bottomAnchor.constraint(equalToSystemSpacingBelow: pageViewController.view.bottomAnchor, multiplier: -40),
            nextButton.trailingAnchor.constraint(equalToSystemSpacingAfter: pageViewController.view.trailingAnchor, multiplier: -8)
        ])
        
    }
    
}

// MARK: - UIPageViewControllerDataSource

extension OnboardingContainerViewController: UIPageViewControllerDataSource {

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return getPreviousViewController(from: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return getNextViewController(from: viewController)
    }

    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
        currentVC = pages[index - 1]
        return pages[index - 1]
    }

    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
        currentVC = pages[index + 1]
        return pages[index + 1]
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return pages.firstIndex(of: self.currentVC) ?? 0
    }
}

// MARK: - Actions

extension OnboardingContainerViewController {
    @objc private func closeTapped(_ sender: UIButton) {
        delegate?.didFinishOnboarding()
    }
    
    @objc private func backTapped(_ sender: UIButton) {
        print("back clicked")
        getPreviousViewController(from: self)
    }
    
    @objc private func nextTapped(_ sender: UIButton) {
        print("next clicked")
        getNextViewController(from: self)
    }
    
    @objc private func doneTapped(_ sender: UIButton) {
        delegate?.didFinishOnboarding()
    }
}


// MARK: - Protocol Abstractions

protocol OnboardingContainerViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

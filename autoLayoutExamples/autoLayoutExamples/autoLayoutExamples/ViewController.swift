//
//  ViewController.swift
//  autoLayoutExamples
//
//  Created by W Lawless on 10/7/22.
//

import UIKit


// MARK: - Layout Margins

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        let centerView = UIView()
        centerView.translatesAutoresizingMaskIntoConstraints = false
        centerView.backgroundColor = .secondarySystemBackground

        view.addSubview(centerView)

        let button1 = makeButton(title: "OK", color: .tertiarySystemBackground)
        let button2 = makeButton(title: "Cancel", color: .systemGreen)

        let leadingGuide = UILayoutGuide()
        let middleGuide = UILayoutGuide()
        let trailingGuide = UILayoutGuide()

        let centerViewMargins = centerView.layoutMarginsGuide

        centerView.addLayoutGuide(leadingGuide)
        centerView.addSubview(button1)
        centerView.addLayoutGuide(middleGuide)
        centerView.addSubview(button2)
        centerView.addLayoutGuide(trailingGuide)

        NSLayoutConstraint.activate([
            centerView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            centerView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            centerView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            centerView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),

            //Leading Margins
            centerViewMargins.leadingAnchor.constraint(equalTo: leadingGuide.leadingAnchor),
            leadingGuide.trailingAnchor.constraint(equalTo: button1.leadingAnchor),

            //Middle Margins
            button1.trailingAnchor.constraint(equalTo: middleGuide.leadingAnchor),
            middleGuide.trailingAnchor.constraint(equalTo: button2.leadingAnchor),

            //Trailing Margins
            button2.trailingAnchor.constraint(equalTo: trailingGuide.leadingAnchor),
            trailingGuide.trailingAnchor.constraint(equalTo: centerViewMargins.trailingAnchor),

            //Button Widths
            button1.widthAnchor.constraint(equalTo: button2.widthAnchor),

            //Spacer Widths
            leadingGuide.widthAnchor.constraint(equalTo: middleGuide.widthAnchor),
            leadingGuide.widthAnchor.constraint(equalTo: trailingGuide.widthAnchor),

            //Vertical Positions
            leadingGuide.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            button1.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            middleGuide.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            button2.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),
            trailingGuide.centerYAnchor.constraint(equalTo: centerView.centerYAnchor),

            //Default heights
            leadingGuide.heightAnchor.constraint(equalToConstant: 1),
            middleGuide.heightAnchor.constraint(equalToConstant: 1),
            trailingGuide.heightAnchor.constraint(equalToConstant: 1)
        ])

    }

    private func makeButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)

        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.setTitle("Clicked", for: .highlighted)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        ///        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 0, trailing: 8)
        button.backgroundColor = color

        return button
    }

    private func makeLabel(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 32)
        label.backgroundColor = .secondarySystemBackground

        return label
    }

}

// MARK: - Basics

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupViews()
//    }
//
//    private func setupViews() {
//        let upperLeftLabel = makeLabel("upperLeft")
//        let upperRightLabel = makeLabel("upperRight")
//        let bottomLeftLabel = makeLabel("bottomLeft")
//        let bottomRightLabel = makeLabel("bottomRight")
//        let centerView = UIView()
//        centerView.translatesAutoresizingMaskIntoConstraints = false
//        centerView.backgroundColor = .secondarySystemBackground
//
//        view.addSubview(upperLeftLabel)
//        view.addSubview(upperRightLabel)
//        view.addSubview(bottomLeftLabel)
//        view.addSubview(bottomRightLabel)
//        view.addSubview(centerView)
//
//        NSLayoutConstraint.activate([
//            upperLeftLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            upperLeftLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//
//            upperRightLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
//            upperRightLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//
//            bottomLeftLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            bottomLeftLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//
//            bottomRightLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -8),
//            bottomRightLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//
//            centerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
//            centerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
//
//            //Explicit Sizing:
////            centerView.heightAnchor.constraint(equalToConstant: 700),
////            centerView.widthAnchor.constraint(equalToConstant: 380),
///     baselineAnchors
//            centerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 8),
//            centerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8),
//
//            centerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
//            centerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80)
//
//        ])
//    }
//
//    private func makeLabel(_ text: String) -> UILabel {
//        let label = UILabel()
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.text = text
//        label.backgroundColor = .secondarySystemBackground
//
//        return label
//    }
//
//}


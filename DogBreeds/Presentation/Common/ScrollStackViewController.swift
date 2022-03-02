//
//  ScrollStackViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

class ScrollStackViewController: UIViewController {
    
    let stackView = UIStackView()
    let scrollView = ScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.alwaysBounceVertical = true
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView, with: view)

        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill

        let frameGuide = scrollView.frameLayoutGuide
        let contentGuide = scrollView.contentLayoutGuide

        scrollView.addSubview(stackView, activate: [
            stackView.topAnchor.constraint(equalTo: contentGuide.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentGuide.bottomAnchor, constant: -20),
            stackView.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
            contentGuide.widthAnchor.constraint(equalTo: frameGuide.widthAnchor)
        ])

        scrollView.preservesSuperviewLayoutMargins = true
        stackView.preservesSuperviewLayoutMargins = true
    }
    
    // MARK: - Managing subviews

    /// Adding view to stack
    func addView(_ view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    // MARK: - Managing child UIViewController

    func addArrangedChild(_ child: UIViewController) {
        addChild(child)
        addView(child.view)

        child.didMove(toParent: self)
    }
}

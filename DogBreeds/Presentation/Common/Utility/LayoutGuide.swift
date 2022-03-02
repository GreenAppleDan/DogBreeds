//
//  LayoutGuide.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

/// - Note: Generalization of  `UIView` and `UILayoutGuide`.
protocol LayoutGuide {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
}

extension UIView: LayoutGuide {}
extension UILayoutGuide: LayoutGuide {}

extension UIView {
    /// Add subview with specific LayoutGuide
    func addSubview(_ subview: UIView, with guide: LayoutGuide) {
        addSubview(subview, activate: [
            subview.topAnchor.constraint(equalTo: guide.topAnchor),
            subview.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            subview.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            subview.leadingAnchor.constraint(equalTo: guide.leadingAnchor)
        ])
    }
    
    /// Add subview and activate constraints
    func addSubview(_ subview: UIView, activate constraints: @autoclosure () -> [NSLayoutConstraint]) {
        subview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(subview)
        NSLayoutConstraint.activate(constraints())
    }
}

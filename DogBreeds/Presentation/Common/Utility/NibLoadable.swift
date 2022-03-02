//
//  NibLoadable.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

protocol NibRepresentable: AnyObject {

    static var className: String { get }

    static var nib: UINib { get }
}

extension NibRepresentable {

    static var className: String {
        return String(describing: self)
    }

    static var nib: UINib {
        return UINib(nibName: className, bundle: nil)
    }
}


protocol NibLoadable: NibRepresentable {}

extension NibLoadable where Self: UIView {

    static func loadFromNib() -> Self {
        let results: [Any] = nib.instantiate(withOwner: self, options: nil)
        for result in results {
            if let view = result as? Self {
                return view
            }
        }
        fatalError("\(self) not found")
    }
}

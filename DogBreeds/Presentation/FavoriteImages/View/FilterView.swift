//
//  FilterView.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit

final class FilterView: UIView, NibLoadable {
    private var onFilterTap: (() -> Void)?
    private var onResetTap: (() -> Void)?
    
    static func make(onFilterTap: (() -> Void)?,
                     onResetTap: (() -> Void)?) -> FilterView {
        let view = loadFromNib()
        view.onFilterTap = onFilterTap
        view.onResetTap = onResetTap
        return view
    }
    
    @IBAction func filterButtonDidTap() {
        onFilterTap?()
    }
    
    @IBAction func resetButtonDidTap() {
        onResetTap?()
    }
    
}

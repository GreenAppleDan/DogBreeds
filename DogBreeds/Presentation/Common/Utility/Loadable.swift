//
//  Loadable.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

protocol Loadable: UIViewController {
    func startLoading()
    func stopLoading(completion: (() -> Void)?)
}

extension Loadable {

    /// Запустить полноэкранный лоадер
    func startLoading() {
        let spinnerVC = SpinnerViewController()
        addChild(spinnerVC)
        view.addSubview(spinnerVC.view, with: view)
    }

    /// Убрать полноэкранный лоадер и выполнить completion по завершению анимации исчезновения
    func stopLoading(completion: (() -> Void)? = nil) {
        guard let spinnerVC = children.first(where: { $0 is SpinnerViewController}) as? SpinnerViewController else { return }

        spinnerVC.willMove(toParent: nil)
        spinnerVC.view.removeFromSuperview()
        spinnerVC.removeFromParent()
    }
}

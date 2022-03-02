//
//  DogBreedsListViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class DogBreedsListViewController: ScrollStackViewController {
    
    private let breedsService: BreedsService
    
    static func make(breedsService: BreedsService) -> UIViewController {
        UINavigationController(rootViewController: Self(breedsService: breedsService))
    }
    
    private init(breedsService: BreedsService) {
        self.breedsService = breedsService
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = .init(systemName: "list.dash")
        title = "Breeds List"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.largeTitleDisplayMode = .always
        return item
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

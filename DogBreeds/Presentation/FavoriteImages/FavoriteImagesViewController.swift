//
//  FavoriteImagesViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class FavoriteImagesViewController: ScrollStackViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem.image = .init(systemName: "star.fill")
        title = "Favorites"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setup()
    }
    
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.largeTitleDisplayMode = .never
        return item
    }
    
    private func setup() {
        
        let favoriteVc = FavoriteImagesListViewController()
        addArrangedChild(favoriteVc)
    }
}

//
//  AppViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class AppViewController: UITabBarController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configure()
    }
    
    private func configure() {
        
        let dogBreedsList = DogBreedsListViewController.make()
        let favoriteImages = FavoriteImagesViewController()
        let tabBarViewControllers = [dogBreedsList, favoriteImages]
        
        setViewControllers(tabBarViewControllers, animated: true)
    }
}

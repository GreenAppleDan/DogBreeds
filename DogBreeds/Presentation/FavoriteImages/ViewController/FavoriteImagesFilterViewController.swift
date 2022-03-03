//
//  FavoriteImagesFilterViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit

protocol FavoriteImagesFilterViewControllerDelegate: AnyObject {
    func favoriteImagesFilterViewControllerDidChooseBreed(_ breed: String)
}
final class FavoriteImagesFilterViewController: ScrollStackViewController {
    
    private let breeds: [String]
    private weak var delegate: FavoriteImagesFilterViewControllerDelegate?
    
    init(breeds: [String],
         delegate: FavoriteImagesFilterViewControllerDelegate?) {
        self.breeds = breeds
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupWith(breeds: breeds)
    }
    
    private func setupWith(breeds: [String]) {
        let breedNameViews = breeds.map { breedName in
            BreedNameView(breedName: breedName) { [weak self] in
                self?.delegate?.favoriteImagesFilterViewControllerDidChooseBreed(breedName)
            }
        }
        
        breedNameViews.forEach{ addView($0) }
    }
}

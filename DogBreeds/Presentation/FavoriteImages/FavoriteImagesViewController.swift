//
//  FavoriteImagesViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class FavoriteImagesViewController: ScrollStackViewController {
    
    private var breedFilterAppliable: BreedFilterAppliable?
    
    private var sortedBreeds = [String]()
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
        stackView.spacing = 10
        setup()
    }
    
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.largeTitleDisplayMode = .never
        return item
    }
    
    private func setup() {
        
        let filterView = FilterView.make(
            onFilterTap: { [weak self] in
                self?.showFilters()
            },
            onResetTap: { [weak self] in
                self?.breedFilterAppliable?.breedFilter = nil
            })
        addView(filterView)
        
        let favoriteVc = FavoriteImagesListViewController(delegate: self)
        breedFilterAppliable = favoriteVc
        addArrangedChild(favoriteVc)
    }
    
    private func showFilters() {
        let vc = FavoriteImagesFilterViewController(breeds: sortedBreeds, delegate: self)
        present(vc, animated: true)
    }
}

extension FavoriteImagesViewController: FavoriteImagesListViewControllerDelegate {
    func favoriteImagesBreedNamesUpdated(uniqueBreedNames: Set<String>) {
        sortedBreeds = Array(uniqueBreedNames).sorted()
    }
}

extension FavoriteImagesViewController: FavoriteImagesFilterViewControllerDelegate {
    func favoriteImagesFilterViewControllerDidChooseBreed(_ breed: String) {
        breedFilterAppliable?.breedFilter = breed
        dismiss(animated: true)
    }
}

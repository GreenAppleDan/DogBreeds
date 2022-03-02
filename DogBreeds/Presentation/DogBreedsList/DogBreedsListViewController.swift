//
//  DogBreedsListViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class DogBreedsListViewController: ScrollStackViewController, Loadable {
    
    private let breedsService: BreedsService
    
    static func make(breedsService: BreedsService) -> UIViewController {
        let navigationController = UINavigationController(rootViewController: Self(breedsService: breedsService))
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
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
        getBreedsList()
    }
    
    private func getBreedsList() {
        startLoading()
        breedsService.breedsList { [weak self] result in
            switch result {
            case .success(let breedsList):
                self?.stopLoading()
                self?.setupWith(breeds: breedsList.breeds)
            default:
                break
            }
        }
    }
    
    private func setupWith(breeds: [String]) {
        let breedNameViews = breeds.map { breedName in
            BreedNameView(breedName: breedName) { [weak self] in
                self?.getBreedImages(breedName: breedName)
            }
        }
        
        breedNameViews.forEach{ addView($0) }
    }
    
    private func getBreedImages(breedName: String) {
        startLoading()
        
        breedsService.breedImages(breed: breedName) { [weak self] result in
            self?.stopLoading()
            
            switch result {
            case .success(let breedImages):
                self?.pushImagesVc(breed: breedName, breedImages: breedImages)
            default:
                break
            }
        }
    }
    
    private func pushImagesVc(breed: String, breedImages: BreedImagesEndpointResponse) {
        let vc = BreedImagesContainerViewController(breed: breed, breedImages: breedImages)
        navigationController?.pushViewController(vc, animated: true)
    }
}

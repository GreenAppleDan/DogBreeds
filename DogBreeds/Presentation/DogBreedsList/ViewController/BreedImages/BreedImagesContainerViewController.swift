//
//  BreedImagesContainerViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit

final class BreedImagesContainerViewController: ScrollStackViewController {
    
    private let breed: String
    private let breedImages: BreedImagesEndpointResponse
    
    init(breed: String, breedImages: BreedImagesEndpointResponse) {
        self.breed = breed
        self.breedImages = breedImages
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        
        let breedImagesVc = BreedImagesViewController(breed: breed, breedImages: breedImages)
        addArrangedChild(breedImagesVc)
    }
}

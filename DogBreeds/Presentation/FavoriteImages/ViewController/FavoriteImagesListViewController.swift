//
//  FavoriteImagesListViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit

final class FavoriteImagesListViewController: UIViewController {
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewHeightConstraint: NSLayoutConstraint!

    private var collectionViewSize: CGSize = .zero
    private var cellSize: CGSize = .zero
    private var cellViewModels: [BreedImageCollectionViewCell.FavoritesViewModel]

    private let cellIdentifier = BreedImageCollectionViewCell.identifier
    private var favoriteBreedsStorage: FavoriteBreedsStorage
    private var favoriteBreeds: FavoriteBreeds
    
    init(favoriteBreedsStorage: FavoriteBreedsStorage = BasicFavoriteBreedsStorage()) {
        
        let favoriteBreeds = favoriteBreedsStorage.favoriteBreeds
        
        self.cellViewModels = favoriteBreeds.value.map {
            BreedImageCollectionViewCell.FavoritesViewModel(imageUrl: $0.imageUrl, breed: $0.breedName)
        }
        
        self.favoriteBreedsStorage = favoriteBreedsStorage
        self.favoriteBreeds = favoriteBreeds
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if collectionViewSize != collectionView.bounds.size {
            collectionViewSize = collectionView.bounds.size
            recalculateCellSize()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    private func updateCollectionView() {
        cellViewModels = favoriteBreedsStorage.favoriteBreeds.value.map {
            BreedImageCollectionViewCell.FavoritesViewModel(imageUrl: $0.imageUrl, breed: $0.breedName)
        }
        collectionView.reloadData()
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let nib = UINib(nibName: cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    private func recalculateCellSize() {
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            cellSize = .zero
            return
        }
        
        let estimatedWidth: CGFloat = 138
        let estimatedHeight: CGFloat = 124
        let spacing = flowLayout.minimumInteritemSpacing
        let allCasesCount = CGFloat(cellViewModels.count)
        var numberOfCells = floor(collectionViewSize.width / estimatedWidth)
        numberOfCells = min(numberOfCells, allCasesCount)
        
        let spaceLeft = collectionViewSize.width - (numberOfCells - 1) * spacing
        
        guard numberOfCells > 0 else {
            cellSize = .zero
            return
        }
        
        let cellWidth = spaceLeft / numberOfCells
        let multiplier = cellWidth / estimatedWidth
        
        let cellHeight = estimatedHeight * multiplier
        
        cellSize = CGSize(width: cellWidth, height: cellHeight)
        
        let numberOfRows = ceil(allCasesCount / numberOfCells)
        
        guard numberOfRows > 0 else { return }
        
        let height = numberOfRows * cellHeight + (numberOfRows - 1) * spacing
        if collectionViewHeightConstraint.constant != height {
            collectionViewHeightConstraint.constant = height
            view.setNeedsLayout()
        }
    }
}
 

extension FavoriteImagesListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
            
            let cellViewModel = cellViewModels[indexPath.row]
            
            (cell as? BreedImageCollectionViewCell)?.configure(mode: .favourites(cellViewModel))
            
            return cell
        }
    
}

extension FavoriteImagesListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
}

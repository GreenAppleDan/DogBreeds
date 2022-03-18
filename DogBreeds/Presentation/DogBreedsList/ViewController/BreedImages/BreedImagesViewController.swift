//
//  BreedImagesViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

enum BreedImagesViewControllerSection {
    case main
}

final class BreedImagesViewController: UICollectionViewController {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<BreedImagesViewControllerSection, BreedImageCollectionViewCell.BasicViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<BreedImagesViewControllerSection, BreedImageCollectionViewCell.BasicViewModel>
    
    private lazy var dataSource = makeDataSource()
    
    private let cellViewModels: [BreedImageCollectionViewCell.BasicViewModel]
    private var collectionViewHeightConstraint: NSLayoutConstraint?
    
    private static let cellIdentifier = BreedImageCollectionViewCell.identifier
    
    private let breed: String
    private var favoriteBreedsStorage: FavoriteBreedsStorage
    private var favoriteBreeds: FavoriteBreeds {
        didSet {
            favoriteBreedsStorage.favoriteBreeds = favoriteBreeds
        }
    }
    
    init(breed: String,
         breedImages: BreedImagesEndpointResponse,
         favoriteBreedsStorage: FavoriteBreedsStorage = BasicFavoriteBreedsStorage()) {
        
        self.breed = breed
        let favoriteBreeds = favoriteBreedsStorage.favoriteBreeds
        self.cellViewModels = breedImages.imageUrls.compactMap {
            guard let imageUrl = $0 else { return nil }
            let isInitiallySelected = favoriteBreeds.value.contains(FavoriteBreed(breedName: breed, imageUrl: imageUrl))
            return BreedImageCollectionViewCell.BasicViewModel(imageUrl: imageUrl, isInitiallySelected: isInitiallySelected)
        }
        
        self.favoriteBreedsStorage = favoriteBreedsStorage
        self.favoriteBreeds = favoriteBreeds
        
        super.init(collectionViewLayout: Self.collectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        applySnapshot()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if collectionViewHeightConstraint == nil {
            let constraint = collectionView.heightAnchor.constraint(equalToConstant: collectionView.collectionViewLayout.collectionViewContentSize.height)
            NSLayoutConstraint.activate([constraint ])
            collectionViewHeightConstraint = constraint
        } else {
            collectionViewHeightConstraint?.constant = collectionView.collectionViewLayout.collectionViewContentSize.height
        }
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        
        let nib = UINib(nibName: Self.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Self.cellIdentifier)
    }
    
    private static func collectionViewLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,
            leading: 10,
            bottom: 10,
            trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.5))
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, cellViewModel) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath)
            
            (cell as? BreedImageCollectionViewCell)?.configure(mode: .basic(cellViewModel))
            
            return cell
        }
        
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(cellViewModels)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }
}

extension BreedImagesViewController: UICollectionViewDelegateFlowLayout {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cellViewModel = cellViewModels[indexPath.row]
        guard let cell = collectionView.cellForItem(at: indexPath) as? BreedImageCollectionViewCell else { return }
        guard let isFavorite = cell.toggleIsFavoriteIfPossible() else { return }
        
        let favoriteBreed = FavoriteBreed(breedName: breed, imageUrl: cellViewModel.imageUrl)
        if isFavorite {
            favoriteBreeds.value.insert(favoriteBreed)
        } else {
            favoriteBreeds.value.remove(favoriteBreed)
        }
    }
}

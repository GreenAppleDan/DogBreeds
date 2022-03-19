//
//  FavoriteImagesListViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit

enum FavoriteImagesViewControllerSection {
    case main
}

protocol FavoriteImagesListViewControllerDelegate: AnyObject {
    func favoriteImagesBreedNamesUpdated(uniqueBreedNames: Set<String>)
}

protocol BreedFilterAppliable {
    var breedFilter: String? { get set }
}

final class FavoriteImagesListViewController: UICollectionViewController, BreedFilterAppliable {
    
    private typealias DataSource = UICollectionViewDiffableDataSource<FavoriteImagesViewControllerSection, BreedImageCollectionViewCell.FavoritesViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<FavoriteImagesViewControllerSection, BreedImageCollectionViewCell.FavoritesViewModel>
    
    private lazy var dataSource = makeDataSource()
    private var collectionViewHeightConstraint: NSLayoutConstraint?

    private var cellViewModels: [BreedImageCollectionViewCell.FavoritesViewModel] = [] {
        didSet {
            let uniqueBreedNames = Set(cellViewModels.map{ $0.breed })
            delegate?.favoriteImagesBreedNamesUpdated(uniqueBreedNames: uniqueBreedNames)
        }
    }
    
    private var filteredCellViewModels: [BreedImageCollectionViewCell.FavoritesViewModel] {
        if let breedFilter = breedFilter {
            return cellViewModels.filter{ $0.breed == breedFilter }
        } else {
            return cellViewModels
        }
    }
    
    var breedFilter: String? = nil {
        didSet {
            if oldValue != breedFilter {
                applySnapshot()
            }
        }
    }

    private static let cellIdentifier = BreedImageCollectionViewCell.identifier
    private var favoriteBreedsStorage: FavoriteBreedsStorage
    private var favoriteBreeds: FavoriteBreeds
    
    private weak var delegate: FavoriteImagesListViewControllerDelegate?
    
    init(favoriteBreedsStorage: FavoriteBreedsStorage = BasicFavoriteBreedsStorage(),
         delegate: FavoriteImagesListViewControllerDelegate?) {
        
        let favoriteBreeds = favoriteBreedsStorage.favoriteBreeds
        
        self.cellViewModels = favoriteBreeds.value.map {
            BreedImageCollectionViewCell.FavoritesViewModel(imageUrl: $0.imageUrl, breed: $0.breedName)
        }
        
        self.favoriteBreedsStorage = favoriteBreedsStorage
        self.favoriteBreeds = favoriteBreeds
        self.delegate = delegate
        
        super.init(collectionViewLayout: Self.collectionViewLayout())
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
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: collectionView) { (collectionView, indexPath, cellViewModel) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Self.cellIdentifier, for: indexPath)
            
            (cell as? BreedImageCollectionViewCell)?.configure(mode: .favourites(cellViewModel))
            
            return cell
        }
        
        return dataSource
    }
    
    private func setupCollectionView() {
        let nib = UINib(nibName: Self.cellIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: Self.cellIdentifier)
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        
        cellViewModels = favoriteBreedsStorage.favoriteBreeds.value.map {
            BreedImageCollectionViewCell.FavoritesViewModel(imageUrl: $0.imageUrl, breed: $0.breedName)
        }
        
        var snapshot = Snapshot()
        
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredCellViewModels)
        
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
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

    
}

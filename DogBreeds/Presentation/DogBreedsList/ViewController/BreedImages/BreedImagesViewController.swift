//
//  BreedImagesViewController.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class BreedImagesViewController: UIViewController {
    
    @IBOutlet private var collectionView: UICollectionView!
    @IBOutlet private var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var collectionViewSize: CGSize = .zero
    private var cellSize: CGSize = .zero
    private let cellViewModels: [BreedImageCollectionViewCell.ViewModel]
    
    private let cellIdentifier = BreedImageCollectionViewCell.identifier
    
    init(breed: String, breedImages: BreedImagesEndpointResponse) {
        
        self.cellViewModels = breedImages.imageUrls.map {
            // TODO: определяй isInitiallySelected по urlrequest.url.absoluteString, который берем из UserDefaults
            BreedImageCollectionViewCell.ViewModel(imageUrl: $0, isInitiallySelected: false)
        }
        
        super.init(nibName: nil, bundle: nil)
        title = breed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        if collectionViewSize != collectionView.bounds.size {
            collectionViewSize = collectionView.bounds.size
            recalculateCellSize()
            collectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    override var navigationItem: UINavigationItem {
        let item = super.navigationItem
        item.largeTitleDisplayMode = .never
        return item
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

extension BreedImagesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellViewModels.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        
        let cellViewModel = cellViewModels[indexPath.row]
        
        (cell as? BreedImageCollectionViewCell)?.configure(viewModel: cellViewModel)
        
        return cell
    }
    
}

extension BreedImagesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        // TODO: меняй видимость сердечка, добавляй/удаляй стрингу из userDefaults
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return cellSize
    }
}

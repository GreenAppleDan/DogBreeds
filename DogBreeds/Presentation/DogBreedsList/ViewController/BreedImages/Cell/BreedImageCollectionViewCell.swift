//
//  BreedImageCollectionViewCell.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit
import ImageLoader

final class BreedImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var heartImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    @IBOutlet private var breedLabel: UILabel!
    
    struct BasicViewModel: Hashable {
        let id: UUID
        let imageUrl: URL
        let isInitiallySelected: Bool
        
        init(imageUrl: URL,
             isInitiallySelected: Bool) {
            id = .init()
            self.imageUrl = imageUrl
            self.isInitiallySelected = isInitiallySelected
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    struct FavoritesViewModel: Hashable {
        let id: UUID
        let imageUrl: URL
        let breed: String
        
        init(imageUrl: URL,
             breed: String) {
            id = .init()
            self.imageUrl = imageUrl
            self.breed = breed
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }
    
    enum Mode {
        case basic(BasicViewModel)
        case favourites(FavoritesViewModel)
    }
    
    static let identifier = String(describing: BreedImageCollectionViewCell.self)
    
    private var mode: Mode?
    
    private var isFavorite = false {
        didSet {
            determineHeartVisibility()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 8
        determineHeartVisibility()
        heartImageView.isHidden = true
    }
    
    private func determineHeartVisibility() {
        heartImageView.alpha = isFavorite ? 1 : 0.3
    }
    
    func configure(mode: Mode) {
        self.mode = mode
        activityIndicator.startAnimating()
        
        let imageUrl: URL
        
        var breedName: String = ""
        
        switch mode {
        case .basic(let viewModel):
            imageUrl = viewModel.imageUrl
        case .favourites(let viewModel):
            imageUrl = viewModel.imageUrl
            breedName = viewModel.breed
        }
        
        mainImageView.load.request(with: imageUrl) { [weak self] _,_,_  in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.heartImageView.isHidden = false
                self?.breedLabel.text = breedName
            }
        }
        
        switch mode {
        case .basic(let viewModel):
            isFavorite = viewModel.isInitiallySelected
        case .favourites:
            isFavorite = true
        }
        
    }
    
    func toggleIsFavoriteIfPossible() -> Bool? {
        guard let mode = mode else { return nil }
        switch mode {
        case .basic:
            isFavorite.toggle()
            return isFavorite
        case .favourites:
            return nil
        }
        
    }
}

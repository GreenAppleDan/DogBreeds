//
//  BreedImageCollectionViewCell.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit
import ImageLoader

final class BreedImageCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        let imageUrl: URL
        let isInitiallySelected: Bool
    }
    
    static let identifier = String(describing: BreedImageCollectionViewCell.self)
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var heartImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
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
    
    func configure(viewModel: ViewModel) {
        activityIndicator.startAnimating()
        
        mainImageView.load.request(with: viewModel.imageUrl) { [weak self] _,_,_  in
            self?.activityIndicator.stopAnimating()
            self?.heartImageView.isHidden = false
        }
        
        isFavorite = viewModel.isInitiallySelected
    }
    
    func toggleIsFavorite() -> Bool {
        isFavorite.toggle()
        return isFavorite
    }
}

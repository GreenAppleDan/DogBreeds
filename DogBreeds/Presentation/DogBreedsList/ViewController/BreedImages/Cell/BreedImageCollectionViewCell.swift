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
        let imageUrl: URL?
        let isInitiallySelected: Bool
    }
    
    static let identifier = String(describing: BreedImageCollectionViewCell.self)
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var heartImageView: UIImageView!
    @IBOutlet private var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func configure(viewModel: ViewModel) {
        // TODO: загружай картинку
        activityIndicator.startAnimating()
        if let imageUrl = viewModel.imageUrl {
            mainImageView.load.request(with: imageUrl) { [weak self] _,_,_  in
                self?.activityIndicator.stopAnimating()
            }
        }
        heartImageView.isHidden = !viewModel.isInitiallySelected
    }
}

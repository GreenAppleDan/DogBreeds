//
//  BreedImageCollectionViewCell.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import UIKit

final class BreedImageCollectionViewCell: UICollectionViewCell {
    
    struct ViewModel {
        let imageUrlRequest: URLRequest?
        let isInitiallySelected: Bool
    }
    
    static let identifier = String(describing: BreedImageCollectionViewCell.self)
    
    @IBOutlet private var mainImageView: UIImageView!
    @IBOutlet private var heartImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    func configure(viewModel: ViewModel) {
        // TODO: загружай картинку
        heartImageView.isHidden = !viewModel.isInitiallySelected
    }
}

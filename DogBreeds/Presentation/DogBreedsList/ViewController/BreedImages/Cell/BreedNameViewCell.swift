//
//  BreedNameView.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import UIKit

final class BreedNameViewCell: UITableViewCell {
    
    var onTap: (() -> Void)?
    
    private let breedLabel = UILabel()
    private let button = UIButton()
    
    static let reuseIdentifier = String(describing: BreedNameViewCell.self)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(breedLabel, activate: [
            breedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            breedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            breedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(greaterThanOrEqualTo: breedLabel.trailingAnchor, constant: 10),
            bottomAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 15)
        ])
        
        button.pin(to: self)
    }
    
    func configure(breedName: String) {
        breedLabel.text = breedName
        
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
    }
    
    @objc private func pressButton() {
        onTap?()
    }
}

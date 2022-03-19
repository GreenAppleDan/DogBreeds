//
//  BreedNameView.swift
//  DogBreeds
//
//  Created by Denis on 20.03.2022.
//

import UIKit

final class BreedNameView: UIView {
    
    private let onTap: (() -> Void)?
    
    init(breedName: String, onTap: (() -> Void)?) {
        self.onTap = onTap
        super.init(frame: .zero)
        setup(breedName: breedName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup(breedName: String) {
        let breedLabel = UILabel()
        breedLabel.text = breedName
        
        addSubview(breedLabel, activate: [
            breedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            breedLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            breedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(greaterThanOrEqualTo: breedLabel.trailingAnchor, constant: 10),
            bottomAnchor.constraint(equalTo: breedLabel.bottomAnchor, constant: 15)
        ])
        
        let separator = UIView()
        separator.backgroundColor = .black
        addSubview(separator, activate: [
            bottomAnchor.constraint(equalTo: separator.bottomAnchor, constant: 0),
            separator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            trailingAnchor.constraint(equalTo: separator.trailingAnchor, constant: 20),
            separator.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        let button = UIButton()
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(pressButton), for: .touchUpInside)
        button.pin(to: self)
    }
    
    @objc private func pressButton() {
        onTap?()
    }
}

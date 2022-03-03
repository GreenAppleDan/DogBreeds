//
//  FavoriteBreedsStorage.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import Foundation

struct FavoriteBreed: Codable, Hashable {
    let breedName: String
    let imageUrl: URL
}

struct FavoriteBreeds: Codable {
    var value: Set<FavoriteBreed>
}

protocol FavoriteBreedsStorage {
    var favoriteBreeds: FavoriteBreeds { get set }
}

final class BasicFavoriteBreedsStorage: FavoriteBreedsStorage {
    
    private let key = "DogBreeds.FavoriteBreeds"
    
    private let storage: DataStorage
    private lazy var encoder = JSONEncoder()
    private lazy var decoder = JSONDecoder()
    
    var favoriteBreeds: FavoriteBreeds {
        
        get {
            if let savedFavorites = try? storage.data(for: key),
               let favorites = try? decoder.decode(FavoriteBreeds.self, from: savedFavorites) {
                return favorites
            } else {
                return FavoriteBreeds(value: Set<FavoriteBreed>())
            }
        }
        
        set {
            guard let encoded = try? encoder.encode(newValue) else { return }
            try? storage.set(encoded, for: key)
        }
    }
    
    init(storage: DataStorage = UserDefaults.standard) {
        self.storage = storage
    }
}

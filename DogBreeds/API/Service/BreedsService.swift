//
//  BreedsService.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

protocol BreedsService {
    func breedsList(completion: @escaping ResultHandler<BreedsListEndpointResponse>)
    func breedImages(breed: String, completion: @escaping ResultHandler<BreedImagesEndpointResponse>)
}

final class BaseBreedsService: APIService, BreedsService {
    func breedsList(completion: @escaping ResultHandler<BreedsListEndpointResponse>) {
        apiClient.request(BreedsListEndpoint(), completionHandler: completion)
    }
    
    func breedImages(breed: String, completion: @escaping ResultHandler<BreedImagesEndpointResponse>) {
        apiClient.request(BreedImagesEndpoint(breed: breed), completionHandler: completion)
    }
}

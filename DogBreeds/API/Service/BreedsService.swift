//
//  BreedsService.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

protocol BreedsService {
    func breedsList(completion: @escaping ResultHandler<BreedsListEndpointResponse>)
}

final class BaseBreedsService: APIService, BreedsService {
    func breedsList(completion: @escaping (AsyncResult<BreedsListEndpointResponse>) -> Void) {
        apiClient.request(BreedsListEndpoint(), completionHandler: completion)
    }
}

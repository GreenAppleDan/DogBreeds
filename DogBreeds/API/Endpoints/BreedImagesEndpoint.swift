//
//  BreedImagesEndpoint.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

struct BreedImagesEndpointResponse: Decodable {
    let message: [String]
}

extension BreedImagesEndpointResponse {
    var imageUrlRequests: [URLRequest?] {
        message.prefix(10).map{
            guard let url = URL(string: $0) else { return nil }
            return URLRequest(url: url)
        }
    }
}

struct BreedImagesEndpoint: BaseEndpoint {
    
    typealias Content = BreedImagesEndpointResponse
    
    private let breed: String
    
    init(breed: String) {
        self.breed = breed
    }
    
    func makeRequest() throws -> URLRequest {
        let url = URL(string: "api/breed/\(breed)/images")!
        return URLRequest.get(url)
    }
}

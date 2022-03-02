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
    var imageUrls: [URL?] {
        message.prefix(10).map{ URL(string: $0) }
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

//
//  BreedsListEndpoint.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

struct BreedsListEndpointResponse: Decodable {
    let message: [String: [String]]
}

extension BreedsListEndpointResponse {
    var breeds: [String] {
        message.map{ $0.key }
    }
}

struct BreedsListEndpoint: BaseEndpoint {
    
    typealias Content = BreedsListEndpointResponse
    
    func makeRequest() throws -> URLRequest {
        let url = URL(string: "api/breeds/list/all")!
        return URLRequest.get(url)
    }
    
}

//
//  ApiService.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

/// Base API Service
class APIService {

    /// API клиент.
    public let apiClient: APIClient

    public init(apiClient: APIClient) {
        self.apiClient = apiClient
    }
}

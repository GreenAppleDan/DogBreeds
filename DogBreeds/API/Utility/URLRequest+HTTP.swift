//
//  URLRequest+HTTP.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

extension URLRequest {

    static func get(_ url: URL) -> URLRequest {
        return URLRequest(url: url)
    }
}

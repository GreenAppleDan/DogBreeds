//
//  ApiRequestAdapter.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation
import Alamofire

/// Adapter for API calls
final class ApiRequestAdapter: RequestAdapter {

    let baseUrl = URL(string: "https://dog.ceo/")!
    
    func adapt(_ urlRequest: URLRequest) -> URLRequest {
        guard let url = urlRequest.url else { return urlRequest }
        
        var request = urlRequest
        request.url = appendingBaseURL(to: url)
        
        return request
    }
    
    // MARK: - Private

    private func appendingBaseURL(to url: URL) -> URL {
        guard url.host == nil else { return url }
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
        components.percentEncodedQuery = url.query
        return components.url!.appendingPathComponent(url.path)
    }
}

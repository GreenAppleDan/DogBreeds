//
//  ApiClient.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation
import Alamofire

typealias APIResult<Value> = Swift.Result<Value, Error>

/// API Client Protocol
protocol APIClient: AnyObject {

    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void) where T: Endpoint
}

final class Client: APIClient {
    
    /// Network session manager
    private let sessionManager: SessionManager
    
    /// Network responses queue
    private let responseQueue = DispatchQueue(
        label: "API.Client.responseQueue",
        qos: .utility)
    
    /// Callback queue
    private let completionQueue = DispatchQueue.main
    
    /// Request adapter
    let requestAdapter: RequestAdapter
    
    init(requestAdapter: RequestAdapter = ApiRequestAdapter()) {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 30.0
        sessionManager = .init(configuration: config)
        sessionManager.adapter = requestAdapter
        self.requestAdapter = requestAdapter
    }
    
    /// Send a request to API
    ///
    /// - Parameters:
    ///   - endpoint: Final point of request
    ///   - completionHandler: Request result processor
    func request<T>(
        _ endpoint: T,
        completionHandler: @escaping (APIResult<T.Content>) -> Void) where T: Endpoint {
        let anyRequest = AnyRequest(create: endpoint.makeRequest)
        
        _ = sessionManager.request(anyRequest).responseData(
            queue: responseQueue) { (response: DataResponse<Data>) in
            
            let result = APIResult<T.Content>(catching: { () throws -> T.Content in
                let data = try response.result.unwrap()
                return try endpoint.content(from: response.response, with: data)
            })
            
            self.completionQueue.async { completionHandler(result) }
        }
    }
}

// MARK: - Helper

/// Wrapper around `URLRequestConvertible` protocol from `Alamofire`.
private struct AnyRequest: Alamofire.URLRequestConvertible {
    let create: () throws -> URLRequest
    
    func asURLRequest() throws -> URLRequest {
        return try create()
    }
}

private extension APIResult {
    var error: Error? {
        switch self {
        case .failure(let error):
            return error
        default:
            return nil
        }
    }
}

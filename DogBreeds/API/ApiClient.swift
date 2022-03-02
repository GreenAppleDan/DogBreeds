//
//  ApiClient.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation
import Alamofire

typealias APIResult<Value> = Swift.Result<Value, Error>

final class ApiClient {
    
    /// Network session manager
    private let sessionManager: Alamofire.SessionManager
    
    /// Network responses queue
    private let responseQueue = DispatchQueue(
        label: "API.Client.responseQueue",
        qos: .utility)
    
    /// Callback queue
    private let completionQueue = DispatchQueue.main
    
    init() {
        let config = URLSessionConfiguration.ephemeral
        config.timeoutIntervalForRequest = 30.0
        sessionManager = .init(configuration: config)
    }
    
    /// Отправить запрос к API.
    ///
    /// - Parameters:
    ///   - endpoint: Конечная точка запроса.
    ///   - completionHandler: Обработчик результата запроса.
    /// - Returns: Прогресс выполнения запроса.
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

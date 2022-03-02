//
//  Result.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 02.03.2022.
//

import Foundation

/// Result of asynchronous execution
///
/// - Note: Added to not be confused with`Alamofire.Result`.
typealias AsyncResult<Value> = Swift.Result<Value, Swift.Error>

/// Обработчик результата.
typealias ResultHandler<Value> = (AsyncResult<Value>) -> Void

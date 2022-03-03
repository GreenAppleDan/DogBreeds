//
//  DataStorage.swift
//  DogBreeds
//
//  Created by Denis Zhukoborskiy on 03.03.2022.
//

import Foundation

/// Binary data storage
public protocol DataStorage: AnyObject {

    /// Saving, updating, or deleting data
    ///
    /// - Parameters:
    ///   - data: Data for recording
    ///   - key: Key related to the data
    /// - Throws: Error saving data
    func set(_ data: Data?, for key: String) throws

    /// Reading the data
    ///
    /// - Parameter key: Key related to the data
    /// - Returns: Saved data, if present
    /// - Throws: Error reading data
    func data(for key: String) throws -> Data?
}

// MARK: - UserDefaults + DataStorage

extension UserDefaults: DataStorage {

    public func set(_ data: Data?, for key: String) throws {
        set(data, forKey: key)
    }

    public func data(for key: String) throws -> Data? {
        return data(forKey: key)
    }
}

//
//  InMemoryStore.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public class InMemoryStore {
    private var countriesCache: CachedCountries?
    
    public init() {}
}

extension InMemoryStore: CountriesStore {
    public func deleteCache() throws {
        countriesCache = nil
    }

    public func insert(_ countries: [LocalCountry], timestamp: Date) throws {
        if countriesCache == nil {
            countriesCache = CachedCountries(countries: countries, timestamp: timestamp)
        }
    }

    public func retrieveAll() throws -> CachedCountries? {
        countriesCache
    }
    
    public func retrieveBookmark(with flagURL: URL) async throws -> Bool? {
        return false
    }
    
    public func insertBookmark(with flagURL: URL) async throws {
    }
}

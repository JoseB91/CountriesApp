//
//  LocalCountriesLoader.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public final class LocalCountriesLoader {
    private let store: CountriesStore
    private let currentDate: () -> Date
    
    public init(store: CountriesStore, currentDate: @escaping () -> Date) {
        self.store = store
        self.currentDate = currentDate
    }
}

public protocol CountryCache {
    func save(_ countries: [Country]) async throws
}

extension LocalCountriesLoader: CountryCache {
    public func save(_ countries: [Country]) async throws {
        do {
            try await store.insert(countries.toLocal(), timestamp: currentDate())
        } catch {
            try await store.deleteCache()
        }
    }
}

extension LocalCountriesLoader {
    private struct FailedLoad: Error {}
    private struct FailedFavoriteSave: Error {}
    
    public func load() async throws -> [Country] {
        if let cache = try await store.retrieve(), CachePolicy.validate(cache.timestamp, against: currentDate()) {
            return cache.countries.toModels()
        } else {
            throw FailedLoad()
        }
    }
    
    public func saveFavorite(for countryId: Int) async throws {
        do {
            try await store.insertFavorite(for: countryId)
        } catch {
            throw FailedFavoriteSave()
        }
    }
}

extension LocalCountriesLoader {
    private struct InvalidCache: Error {}
    
    public func validateCache() async throws {
        do {
            if let cache = try await store.retrieve(),
               !CachePolicy.validate(cache.timestamp,
                                     against: currentDate()) {
                throw InvalidCache()
            }
        } catch {
            try await store.deleteCache()
        }
    }
}

extension Array where Element == Country {
    public func toLocal() -> [LocalCountry] {
        return map { LocalCountry(commonName: $0.commonName,
                                  officialName: $0.officialName,
                                  capital: $0.capital,
                                  flagURL: $0.flagURL,
                                  isFavorite: $0.isFavorite)
        }
    }
}

private extension Array where Element == LocalCountry {
    func toModels() -> [Country] {
        return map { Country(commonName: $0.commonName,
                             officialName: $0.officialName,
                             capital: $0.capital,
                             flagURL: $0.flagURL,
                             isFavorite: $0.isFavorite)
        }
    }
}

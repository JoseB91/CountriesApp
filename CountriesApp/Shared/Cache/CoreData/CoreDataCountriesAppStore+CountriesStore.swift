//
//  CoreDataCountriesAppStore+CountriesStore.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import CoreData

extension CoreDataCountriesAppStore: CountriesStore {
    
    public func retrieveAll() async throws -> CachedCountries? {
        try await context.perform { [context] in
            try ManagedCache.find(in: context).map {
                CachedCountries(countries: $0.localCountries, timestamp: $0.timestamp)
            }
        }
    }
    
    public func retrieveBookmark(with flagURL: URL) async throws -> Bool? {
        try await context.perform { [context] in
            let country = try ManagedCountry.getCountry(with: flagURL, in: context)
            return country?.isBookmarked
        }
    }
        
    public func insert(_ countries: [LocalCountry], timestamp: Date) async throws {
        try await context.perform { [context] in
            if try !ManagedCache.cacheExists(in: context) {
                let managedCache = try ManagedCache.newUniqueInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.countries = ManagedCountry.fetchCountries(from: countries, in: context)
                try context.save()
            }
        }
    }
    
    public func deleteCache() async throws {
        try await context.perform { [context] in
            try ManagedCache.deleteCache(in: context)
        }
    }
    
    public func insertBookmark(with flagURL: URL) async throws {
        try await context.perform { [context] in
            let managedCountry = try ManagedCountry.getCountry(with: flagURL, in: context)
            managedCountry?.isBookmarked.toggle()
            try context.save()
        }
    }
}

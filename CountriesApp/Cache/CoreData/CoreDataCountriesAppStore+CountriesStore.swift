//
//  CoreDataCountriesAppStore+CountriesStore.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import CoreData

extension CoreDataCountriesAppStore: CountriesStore {
    
    public func retrieve() async throws -> CachedCountries? {
        try await context.perform { [context] in
            try ManagedCache.find(in: context).map {
                CachedCountries(countries: $0.localCountries, timestamp: $0.timestamp)
            }
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
    
    public func insertFavorite(with flagURL: URL) async throws {
        try await context.perform { [context] in
            let managedCountry = try ManagedCountry.getCountry(with: flagURL, in: context)
            managedCountry?.isFavorite.toggle()
            try context.save()
        }
    }
}

//TODO: Add tests and InMemory

//
//  CountriesStore.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public typealias CachedCountries = (countries: [LocalCountry], timestamp: Date)

public protocol CountriesStore {
    func deleteCache() async throws
    func insert(_ countries: [LocalCountry], timestamp: Date) async throws
    func retrieve() async throws -> CachedCountries?
    func insertFavorite(with flagURL: URL) async throws
}

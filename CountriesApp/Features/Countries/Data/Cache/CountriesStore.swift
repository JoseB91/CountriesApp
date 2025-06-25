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
    func retrieveAll() async throws -> CachedCountries?
    func retrieveBookmark(with flagURL: URL) async throws -> Bool?
    func insertBookmark(with flagURL: URL) async throws
}

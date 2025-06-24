//
//  CountriesStoreSpecs.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

protocol CountriesStoreSpecs {
    func test_insert_deliversNoErrorOnEmptyCache() async throws
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws
    func test_insert_doNotSaveOnNonEmptyCache() async throws
    
    func test_delete_deliversNoErrorOnEmptyCache() async throws
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws
    func test_delete_emptiesPreviouslyInsertedCache() async throws
}

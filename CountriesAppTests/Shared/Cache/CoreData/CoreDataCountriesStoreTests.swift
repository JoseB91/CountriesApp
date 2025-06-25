//
//  CoreDataCountriesStoreTests.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

import XCTest
@testable import CountriesApp

//TODO: Add retrieve tests

class CoreDataCountriesStoreTests: XCTestCase, CountriesStoreSpecs {
    
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_insert_doNotSaveOnNonEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatInsertDoNotSaveOnNonEmptyCache(on: sut)
        }
    }

    func test_delete_deliversNoErrorOnEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
        }
    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
        }
    }
    
    func test_delete_deliversNoErrorOnNonEmptyCache() async throws {
        try await makeSUT { sut in
            await self.assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
        }
    }
    
    func test_delete_emptiesPreviouslyInsertedCache() async throws {
        try await makeSUT { sut in
            await self.assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
        }
    }
    
    // - MARK: Helpers
    
    private func makeSUT(_ test: @escaping (CoreDataCountriesAppStore) async throws -> Void, file: StaticString = #filePath, line: UInt = #line) async throws {
            let storeURL = URL(fileURLWithPath: "/dev/null")
            let sut = try CoreDataCountriesAppStore(storeURL: storeURL)
            trackForMemoryLeaks(sut, file: file, line: line)
            
            try await withCheckedThrowingContinuation { continuation in
                sut.context.perform {
                    Task {
                        do {
                            try await test(sut)
                            continuation.resume()
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    }
                }
            }
        }
}

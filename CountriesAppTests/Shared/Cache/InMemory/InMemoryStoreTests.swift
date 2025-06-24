//
//  InMemoryStoreTests.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

import XCTest
import CountriesApp

class InMemoryStoreTests: XCTestCase, CountriesStoreSpecs {
    
    func test_insert_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatInsertDeliversNoErrorOnEmptyCache(on: sut)
    }

    func test_insert_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatInsertDeliversNoErrorOnNonEmptyCache(on: sut)
    }
    
    func test_insert_doNotSaveOnNonEmptyCache() async throws {
        let sut = makeSUT()
        
        await assertThatInsertDoNotSaveOnNonEmptyCache(on: sut)
    }

    func test_delete_deliversNoErrorOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteDeliversNoErrorOnEmptyCache(on: sut)
    }

    func test_delete_hasNoSideEffectsOnEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteHasNoSideEffectsOnEmptyCache(on: sut)
    }

    func test_delete_deliversNoErrorOnNonEmptyCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteDeliversNoErrorOnNonEmptyCache(on: sut)
    }

    func test_delete_emptiesPreviouslyInsertedCache() async throws {
        let sut = makeSUT()

        await assertThatDeleteEmptiesPreviouslyInsertedCache(on: sut)
    }

    // - MARK: Helpers

    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> InMemoryStore {
        let sut = InMemoryStore()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }

}


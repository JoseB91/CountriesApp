//
//  SaveCountriesCacheTests.swift
//  CountriesAppTests
//
//  Created by José Briones on 23/6/25.
//

import XCTest
import CountriesApp

final class SaveCountriesCacheTests: XCTestCase {
    
    func test_save_succeedsOnSuccessfulCacheInsertion() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: nil, when: {
            store.completeInsertionSuccessfully()
        })
    }
    
    func test_save_deletesCacheOnInsertionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: insertionError, when: {
            store.completeInsertion(with: insertionError)
            store.completeDeletionSuccessfully()
        })
    }
    
    func test_save_failsOnInsertionErrorAndDeletionError() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWithError: anyNSError(), when: {
            store.completeInsertion(with: anyNSError())
            store.completeDeletion(with: anyNSError())
        })
    }
    
    func test_save_succeedsOnSuccessfulFavoriteInsertion() async {
        // Arrange
        let flagURL = anyURL()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expectFavorite(sut, with: flagURL, toCompleteWithError: nil, when: {
            store.completeFavoriteInsertionSuccessfully()
        })
    }
    
    func test_save_failsOnFavoriteInsertionError() async {
        // Arrange
        let flagURL = anyURL()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expectFavorite(sut, with: flagURL, toCompleteWithError: anyNSError(), when: {
            store.completeFavoriteInsertion(with: anyNSError())
        })
    }
    
    // MARK: - Helpers

    private func makeSUT(currentDate: @escaping () -> Date = Date.init, file: StaticString = #filePath, line: UInt = #line) -> (sut: LocalCountriesLoader, store: CountriesStoreSpy) {
        let store = CountriesStoreSpy()
        let sut = LocalCountriesLoader(store: store, currentDate: currentDate)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }

    private func expect(_ sut: LocalCountriesLoader, toCompleteWithError expectedError: NSError?, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            try await sut.save(mockCountries().models)
            
            await action()
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
    
    private func expectFavorite(_ sut: LocalCountriesLoader, with flagURL: URL, toCompleteWithError expectedError: NSError?, when action: () async -> Void?, file: StaticString = #filePath, line: UInt = #line) async {
        do {
            // Act
            try await sut.saveFavorite(with: flagURL)
            
            await action()
        } catch {
            // Assert
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}


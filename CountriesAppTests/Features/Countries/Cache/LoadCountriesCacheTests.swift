//
//  LoadCountriesCacheTests.swift
//  CountriesAppTests
//
//  Created by José Briones on 23/6/25.
//

import XCTest
import CountriesApp

final class LoadShowsCacheTests: XCTestCase {
    
    func test_load_requestsCacheRetrieval() async {
        // Arrange
        let (sut, store) = makeSUT()
        
        // Act
        _ = try? await sut.load()
        
        // Assert
        XCTAssertEqual(store.receivedMessages, [.retrieveAll])
    }
        
    func test_load_deliversCachedShowsOnNonExpiredCache() async {
        // Arrange
        let countries = mockCountries()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .success(countries.models), when: {
            store.completeRetrieval(with: countries.local, timestamp: nonExpiredTimestamp)
        })
    }
        
    func test_load_failsOnExpiredCache() async {
        // Arrange
        let countries = mockCountries()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()

        // Act & Assert
        await expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrievalWithExpiredCache(with: countries.local, timestamp: expiredTimestamp, error: retrievalError)
        })
    }
        
    func test_load_failsOnRetrievalError() async {
        // Arrange
        let retrievalError = anyNSError()
        let (sut, store) = makeSUT()
        
        // Act & Assert
        await expect(sut, toCompleteWith: .failure(retrievalError), when: {
            store.completeRetrieval(with: retrievalError)
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
    
    private func expect(_ sut: LocalCountriesLoader, toCompleteWith expectedResult: Result<[Country], Error>, when action: () async -> Void, file: StaticString = #filePath, line: UInt = #line) async {
        await action()

        let receivedResult: Result<[Country], Error>
        
        do {
            let receivedCountries = try await sut.load()
            receivedResult = .success(receivedCountries)
        } catch {
            receivedResult = .failure(error)
        }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedCountries), .success(expectedCountries)):
            XCTAssertEqual(receivedCountries, expectedCountries, file: file, line: line)
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}



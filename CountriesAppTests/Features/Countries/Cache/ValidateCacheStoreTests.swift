//
//  ValidateCacheStoreTests.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

import XCTest
@testable import CountriesApp

class ValidateCacheTests: XCTestCase {
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfExpiredCache() async {
        let leagues = mockCountries()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: leagues.local, timestamp: expiredTimestamp)
            store.completeDeletionSuccessfully()
        })
    }
    
    func test_validateCache_succeedsOnNonExpiredCache() async {
        let leagues = mockCountries()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: leagues.local, timestamp: nonExpiredTimestamp)
        })
    }
    
    func test_validateCache_succeedsOnSuccessfulDeletionOfFailedRetrieval() async {
        let (sut, store) = makeSUT()

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletionSuccessfully()
        })
    }
    
    func test_validateCache_succeedsOnEmptyCache() async {
        let (sut, store) = makeSUT()

        await expect(sut, toCompleteWith: .success(()), when: {
            store.completeRetrievalWithEmptyCache()
        })
    }
    
    func test_validateCache_deletesCacheOnRetrievalError() async {
        let (sut, store) = makeSUT()
        store.completeRetrieval(with: anyNSError())
        
        try? await sut.validateCache()

        XCTAssertEqual(store.receivedMessages, [.retrieveAll, .delete])
    }

    func test_validateCache_doesNotDeleteCacheOnEmptyCache() async {
        let (sut, store) = makeSUT()
        store.completeRetrievalWithEmptyCache()

        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieveAll])
    }
        
    func test_validateCache_deletesOnCacheExpiration() async {
        let leagues = mockCountries()
        let fixedCurrentDate = Date()
        let expirationTimestamp = fixedCurrentDate.minusFeedCacheMaxAge()
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.completeRetrieval(with: leagues.local, timestamp: expirationTimestamp)

        try? await sut.validateCache()

        XCTAssertEqual(store.receivedMessages, [.retrieveAll, .delete])
    }
    
    func test_validateCache_deletesOnExpiredCache() async {
        let leagues = mockCountries()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.completeRetrieval(with: leagues.local, timestamp: expiredTimestamp)

        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieveAll, .delete])
    }
    
    func test_validateCache_doesNotDeleteOnNonExpiredCache() async {
        let leagues = mockCountries()
        let fixedCurrentDate = Date()
        let nonExpiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: 1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        store.completeRetrieval(with: leagues.local, timestamp: nonExpiredTimestamp)
        
        try? await sut.validateCache()
        
        XCTAssertEqual(store.receivedMessages, [.retrieveAll])
    }
    
    func test_validateCache_failsOnDeletionErrorOfFailedRetrieval() async {
        let (sut, store) = makeSUT()

        await expect(sut, toCompleteWith: .failure(anyNSError()), when: {
            store.completeRetrieval(with: anyNSError())
            store.completeDeletion(with: anyNSError())
        })
    }
    
    func test_validateCache_failsOnDeletionErrorOfExpiredCache() async {
        let leagues = mockCountries()
        let fixedCurrentDate = Date()
        let expiredTimestamp = fixedCurrentDate.minusFeedCacheMaxAge().adding(seconds: -1)
        let (sut, store) = makeSUT(currentDate: { fixedCurrentDate })
        let deletionError = anyNSError()

        await expect(sut, toCompleteWith: .failure(deletionError), when: {
            store.completeRetrieval(with: leagues.local, timestamp: expiredTimestamp)
            store.completeDeletion(with: deletionError)
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
    
    private func expect(_ sut: LocalCountriesLoader, toCompleteWith expectedResult: Result<Void, Error>, when action: () async -> Void, file: StaticString = #file, line: UInt = #line) async {
        await action()
        
        let receivedResult : Result<Void, Error>
        
        do {
            try await sut.validateCache()
            receivedResult = .success(())
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}

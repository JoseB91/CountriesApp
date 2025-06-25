//
//  XCTestCase+CountriesStoreSpecs.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

import XCTest
import CountriesApp

extension CountriesStoreSpecs where Self: XCTestCase {
    func assertThatInsertDeliversNoErrorOnEmptyCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        let insertionError = await insert((mockCountries().local, Date()), to: sut)
        
        // Assert
        XCTAssertNil(insertionError, "Expected to insert cache successfully", file: file, line: line)
    }
    
    func assertThatInsertDeliversNoErrorOnNonEmptyCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert((mockCountries().local, Date()), to: sut)
                
        let insertionError = await insert((mockCountries().local, Date()), to: sut)
   
        //Assert
        XCTAssertNil(insertionError, "Expected to insert just once without error", file: file, line: line)
    }
    
    func assertThatInsertDoNotSaveOnNonEmptyCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        let timestamp = Date()
        await insert((mockCountries().local, timestamp), to: sut)
                
        await insert(([LocalCountry(commonName: "Ecuador",
                                    officialName: "Republic of Ecuador",
                                    capital: "Quito",
                                    flagURL: anyURL(),
                                    isBookmarked: false)], Date()), to: sut)
   
        //Assert
        await expect(sut, toRetrieve: .success(CachedCountries(countries: mockCountries().local, timestamp: timestamp)))
    }
        
    func assertThatDeleteDeliversNoErrorOnEmptyCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        let deletionError = await deleteCache(from: sut)
        
        // Assert
        XCTAssertNil(deletionError, "Expected empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteHasNoSideEffectsOnEmptyCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await deleteCache(from: sut)
        
        // Assert
        await expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
    
    func assertThatDeleteDeliversNoErrorOnNonEmptyCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert((mockCountries().local, Date()), to: sut)
        let deletionError = await deleteCache(from: sut)
        
        // Assert
        XCTAssertNil(deletionError, "Expected non-empty cache deletion to succeed", file: file, line: line)
    }
    
    func assertThatDeleteEmptiesPreviouslyInsertedCache(on sut: CountriesStore, file: StaticString = #file, line: UInt = #line) async {
        // Act
        await insert((mockCountries().local, Date()), to: sut)
        await deleteCache(from: sut)
        
        // Assert
        await expect(sut, toRetrieve: .success(.none), file: file, line: line)
    }
        
    @discardableResult
    func insert(_ cache: (countries: [LocalCountry], timestamp: Date), to sut: CountriesStore) async -> Error? {
        do {
            // Act
            try await sut.insert(cache.countries, timestamp: cache.timestamp)
            return nil
        } catch {
            return error
        }
    }
    
    @discardableResult
    func deleteCache(from sut: CountriesStore) async -> Error? {
        do {
            // Act
            try await sut.deleteCache()
            return nil
        } catch {
            return error
        }
    }
    func expect(_ sut: CountriesStore, toRetrieve expectedResult: Result<CachedCountries?, Error>, file: StaticString = #filePath, line: UInt = #line) async {
        
        // Act
        let retrievedResult: Result<CachedCountries?, Error>
        
        do {
            let retrievedLeagues = try await sut.retrieve()
            retrievedResult = .success(retrievedLeagues)
        } catch {
            retrievedResult = .failure(error)
        }

        switch (expectedResult, retrievedResult) {
        case (.success(.none), .success(.none)),
             (.failure, .failure):
            break

        case let (.success(.some(expected)), .success(.some(retrieved))):
            // Assert
            XCTAssertEqual(retrieved.countries, expected.countries, file: file, line: line)
            XCTAssertEqual(retrieved.timestamp, expected.timestamp, file: file, line: line)

        default:
            // Assert
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead", file: file, line: line)
        }
    }
}

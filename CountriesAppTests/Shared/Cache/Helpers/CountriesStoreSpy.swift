//
//  CountriesStoreSpy.swift
//  CountriesAppTests
//
//  Created by José Briones on 23/6/25.
//

import Foundation
import CountriesApp

public class CountriesStoreSpy: CountriesStore {
    enum ReceivedMessage: Equatable {
        case delete
        case insert([LocalCountry], Date)
        case retrieve
        case insertBookmark(URL)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalResult: Result<CachedCountries?, Error>?
    private var favoriteInsertionResult: Result<Void, Error>?

    // MARK: Delete
    public func deleteCache() async throws {
        receivedMessages.append(.delete)
        try deletionResult?.get()
    }

    func completeDeletion(with error: Error) {
        deletionResult = .failure(error)
    }

    func completeDeletionSuccessfully() {
        deletionResult = .success(())
    }
    
    // MARK: Insert
    public func insert(_ countries: [LocalCountry], timestamp: Date) async throws {
        receivedMessages.append(.insert(countries, timestamp))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error) {
        insertionResult = .failure(error)
    }

    func completeInsertionSuccessfully() {
        insertionResult = .success(())
    }
    
    // MARK: Retrieve
    public func retrieve() async throws -> CachedCountries? {
        receivedMessages.append(.retrieve)
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalResult = .success(.none)
    }
    
    func completeRetrievalWithExpiredCache(with countries: [LocalCountry], timestamp: Date, error: Error) {
        retrievalResult = .failure(error)
    }

    func completeRetrieval(with countries: [LocalCountry], timestamp: Date) {
        retrievalResult = .success(CachedCountries(countries: countries, timestamp: timestamp))
    }
    
    // MARK: Insert Favorite
    public func insertBookmark(with flagURL: URL) async throws {
        receivedMessages.append(.insertBookmark(flagURL))
        try favoriteInsertionResult?.get()
    }
    
    func completeFavoriteInsertion(with error: Error) {
        favoriteInsertionResult = .failure(error)
    }
    
    func completeFavoriteInsertionSuccessfully() {
        favoriteInsertionResult = .success(())
    }

}

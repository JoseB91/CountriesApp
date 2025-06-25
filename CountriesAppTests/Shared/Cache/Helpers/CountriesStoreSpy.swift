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
        case retrieveAll
        case retrieveBookmark(URL)
        case insertBookmark(URL)
    }
    
    private(set) var receivedMessages = [ReceivedMessage]()
    
    private var deletionResult: Result<Void, Error>?
    private var insertionResult: Result<Void, Error>?
    private var retrievalAllResult: Result<CachedCountries?, Error>?
    private var bookmarkInsertionResult: Result<Void, Error>?
    private var bookmarkRetrievalResult: Result<Bool?, Error>?


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
    
    // MARK: Retrieve All
    public func retrieveAll() async throws -> CachedCountries? {
        receivedMessages.append(.retrieveAll)
        return try retrievalAllResult?.get()
    }

    func completeRetrieval(with error: Error) {
        retrievalAllResult = .failure(error)
    }
    
    func completeRetrievalWithEmptyCache() {
        retrievalAllResult = .success(.none)
    }
    
    func completeRetrievalWithExpiredCache(with countries: [LocalCountry], timestamp: Date, error: Error) {
        retrievalAllResult = .failure(error)
    }

    func completeRetrieval(with countries: [LocalCountry], timestamp: Date) {
        retrievalAllResult = .success(CachedCountries(countries: countries, timestamp: timestamp))
    }
    
    // MARK: Insert Bookmark
    public func insertBookmark(with flagURL: URL) async throws {
        receivedMessages.append(.insertBookmark(flagURL))
        try bookmarkInsertionResult?.get()
    }
    
    func completeFavoriteInsertion(with error: Error) {
        bookmarkInsertionResult = .failure(error)
    }
    
    func completeFavoriteInsertionSuccessfully() {
        bookmarkInsertionResult = .success(())
    }
    
    //MARK: Retrieve Bookmark
    public func retrieveBookmark(with flagURL: URL) async throws -> Bool? {
        receivedMessages.append(.retrieveBookmark(flagURL))
        return try bookmarkRetrievalResult?.get()
    }
    
    func completeBookmarkRetrieval(with error: Error) {
        bookmarkRetrievalResult = .failure(error)
    }
    
    func completeBookmarkRetrieval(with bookmark: Bool) {
        bookmarkRetrievalResult = .success(bookmark)
    }

}

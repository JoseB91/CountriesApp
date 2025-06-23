//
//  URLSessionHTTPClient.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL) async throws -> (Data, HTTPURLResponse)
}

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession) {
        self.session = session
    }
            
    public func get(from url: URL) async throws -> (Data, HTTPURLResponse) {
        
        guard let (data, response) = try? await session.data(from: url) else {
            throw URLError(.cannotLoadFromNetwork)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        return (data, httpResponse)
    }
}

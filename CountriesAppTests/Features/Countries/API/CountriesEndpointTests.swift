//
//  CountriesEndpointTests.swift
//  CountriesAppTests
//
//  Created by José Briones on 23/6/25.
//

import XCTest
import CountriesApp

class CountriesEndpointTests: XCTestCase {
    
    func test_countriesEndpointURL() {
        // Arrange
        let baseURL = URL(string: "https://restcountries.com/v3.1/")!
 
        // Act
        let received = CountriesEndpoint.getCountries.url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "restcountries.com", "host")
        XCTAssertEqual(received.path, "/v3.1/all", "path")
        XCTAssertEqual(received.query?.contains("fields=name,flags,capital"), true)
    }
}

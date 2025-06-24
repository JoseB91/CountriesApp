//
//  CountryDetailEndpointTests.swift
//  CountriesAppTests
//
//  Created by Narcisa Romero on 24/6/25.
//

import XCTest
import CountriesApp

class CountryDetailEndpointTests: XCTestCase {
    
    func test_countryDetailEndpointURL() {
        // Arrange
        let baseURL = URL(string: "https://restcountries.com/v3.1/")!
 
        // Act
        let received = CountryDetailEndpoint.getCountryDetail(name: "ecuador").url(baseURL: baseURL)
        
        // Assert
        XCTAssertEqual(received.scheme, "https", "scheme")
        XCTAssertEqual(received.host, "restcountries.com", "host")
        XCTAssertEqual(received.path, "/v3.1/ecuador", "path")
    }
}

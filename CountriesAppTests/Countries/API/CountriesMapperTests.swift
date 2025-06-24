//
//  CountriesMapperTests.swift
//  CountriesAppTests
//
//  Created by José Briones on 23/6/25.
//

import XCTest
@testable import CountriesApp

final class CountriesMapperTests: XCTestCase {
    
    func test_map_deliversItemsOn200HTTPResponseWithJSONItems() throws {
        // Arrange
        let item = MockCountriesViewModel.mockCountry()
        let jsonString = #"[{"flags":{"png":"https://flagcdn.com/w320/tg.png","svg":"https://flagcdn.com/tg.svg","alt":"The flag of Togo is composed of five equal horizontal bands of green alternating with yellow. A red square bearing a five-pointed white star is superimposed in the canton."},"name":{"common":"Togo","official":"Togolese Republic","nativeName":{"fra":{"official":"République togolaise","common":"Togo"}}},"capital":["Lomé"]}]"#
        
        let json = jsonString.makeJSON()
        
        // Act
        let result = try CountriesMapper.map(json, from: HTTPURLResponse(statusCode: 200))
        
        // Assert
        XCTAssertEqual(result, [item])
    }
    
    func test_map_throwsErrorOnNon200HTTPResponse() throws {
        // Arrange
        let json = "".makeJSON()
        let samples = [199, 201, 300, 400, 500]
        
        try samples.forEach { code in
            // Assert
            XCTAssertThrowsError(
                // Act
                try CountriesMapper.map(json, from: HTTPURLResponse(statusCode: code))
            )
        }
    }
    
    func test_map_throwsErrorOn200HTTPResponseWithInvalidJSON() {
        // Arrange
        let invalidJSON = Data("invalid json".utf8)
        
        // Assert
        XCTAssertThrowsError(
            // Act
            try CountriesMapper.map(invalidJSON, from: HTTPURLResponse(statusCode: 200))
        )
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(url: anyURL(), statusCode: statusCode, httpVersion: nil, headerFields: nil)!
    }
}

extension String {
    func makeJSON() -> Data {
        return self.data(using: .utf8)!
    }
}

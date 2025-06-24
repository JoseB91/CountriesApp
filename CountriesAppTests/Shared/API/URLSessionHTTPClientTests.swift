//
//  URLSessionHTTPClientTests.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import XCTest
import CountriesApp

final class URLSessionHTTPClientTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        URLProtocolStub.startInterceptingRequests()
    }

    override func tearDown() {
        URLProtocolStub.stopInterceptingRequests()
        super.tearDown()
    }
    
    func test_getFromURL_performsGETRequestWithURL() async throws {
        let sut = makeSUT()
        let url = anyURL()
        
        URLProtocolStub.request = nil
        
        _ = try? await sut.get(from: url)

        XCTAssertEqual(URLProtocolStub.request?.url, url)
        XCTAssertEqual(URLProtocolStub.request?.httpMethod, "GET")
    }
    
    func test_getFromURL_throwsErrorOnRequestFailure() async {
        let sut = makeSUT()
        
        URLProtocolStub.error = URLError(.notConnectedToInternet)
        
        do {
            _ = try await sut.get(from: anyURL())
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .cannotLoadFromNetwork)
        }
    }

    func test_getFromURL_throwsErrorOnNonHTTPResponse() async {
        let sut = makeSUT()
        
        URLProtocolStub.response = URLResponse()
        URLProtocolStub.data = anyData()
        
        do {
            _ = try await sut.get(from: anyURL())
            XCTFail("Expected to throw")
        } catch {
            XCTAssertEqual((error as? URLError)?.code, .badServerResponse)
        }
    }
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> HTTPClient {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [URLProtocolStub.self]
        
        let session = URLSession(configuration: config)
        let sut = URLSessionHTTPClient(session: session)

        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    // MARK: - Helpers
        
    func anyData() -> Data {
        return Data("any data".utf8)
    }
}

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
    
    func test_getFromURL_performsGETRequestWithURL() async throws {
        let sut = makeSUT()
        let url = anyURL()
        
        URLProtocolStub.request = nil
        
        _ = try? await sut.get(from: url)

        XCTAssertEqual(URLProtocolStub.request?.url, url)
        XCTAssertEqual(URLProtocolStub.request?.httpMethod, "GET")
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
    
    func anyURL() -> URL {
        return URL(string: "http://any-url.com")!
    }
    
    func anyData() -> Data {
        return Data("any data".utf8)
    }
}

final class URLProtocolStub: URLProtocol {
    static var data: Data?
    static var response: URLResponse?
    static var error: Error?
    static var request: URLRequest?
    
    static func startInterceptingRequests() {
        URLProtocol.registerClass(URLProtocolStub.self)
    }
    
    static func stopInterceptingRequests() {
        URLProtocol.unregisterClass(URLProtocolStub.self)
        data = nil
        response = nil
        error = nil
        request = nil
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        self.request = request
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
            guard let client = client else { return }

            if let error = Self.error {
                client.urlProtocol(self, didFailWithError: error)
            } else {
                let dummyData = Self.data ?? Data()
                let dummyResponse = Self.response ?? HTTPURLResponse(
                    url: request.url!,
                    statusCode: 200,
                    httpVersion: nil,
                    headerFields: nil
                )!

                client.urlProtocol(self, didReceive: dummyResponse, cacheStoragePolicy: .notAllowed)
                client.urlProtocol(self, didLoad: dummyData)
                client.urlProtocolDidFinishLoading(self)
            }
        }

    override func stopLoading() {}
}


extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}


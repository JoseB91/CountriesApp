//
//  URLProtocolStub.swift
//  CountriesAppTests
//
//  Created by José Briones on 23/6/25.
//

import Foundation

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

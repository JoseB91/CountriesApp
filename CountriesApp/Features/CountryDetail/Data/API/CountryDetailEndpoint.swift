//
//  CountryDetailEndpoint.swift
//  CountriesApp
//
//  Created by Narcisa Romero on 24/6/25.
//

import Foundation

public enum CountryDetailEndpoint {
    case getCountryDetail(name: String)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .getCountryDetail(name):
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/name/\(name)"
            return components.url!
        }
    }
}

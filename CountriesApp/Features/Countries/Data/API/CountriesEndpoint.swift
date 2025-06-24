//
//  CountriesEndpoint.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public enum CountriesEndpoint {
    case getCountries
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .getCountries:
            var components = URLComponents()
            components.scheme = baseURL.scheme
            components.host = baseURL.host
            components.path = baseURL.path + "/all"
            components.queryItems = [
                URLQueryItem(name: "fields", value: "name,flags,capital"),
            ]
            return components.url!
        }
    }
}
//?fields=name,flags,capital,region,subregion,timezones,population,languages,currencies,coatOfArms

//
//  CountriesMapper.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public final class CountriesMapper {
    
    private struct Root: Decodable {
        let flags: Flags
        let name: Name
        let capital: [String]
        
        struct Flags: Decodable {
            let png: URL
        }
        
        struct Name: Decodable {
            let common, official: String
        }
        
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> [Country] {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            let countries = rootArray.map { Country(commonName: $0.name.common,
                                                    officialName: $0.name.official,
                                                    capital: $0.capital.joined(separator: ","),
                                                    flagURL: $0.flags.png,
                                                    isFavorite: false) }
            return countries
        } catch {
            throw error
        }
    }
}

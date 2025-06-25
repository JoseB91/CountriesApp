//
//  CountryDetailMapper.swift
//  CountriesApp
//
//  Created by Narcisa Romero on 24/6/25.
//

import Foundation

public final class CountryDetailMapper {
    
    private struct Root: Decodable {
        let name: Name
        let flags: Flags
        //let currencies: Currencies
        let capital: [String]
        let region, subregion: String
        //let languages: Languages
        let population: Int
        let car: Car
        let timezones: [String]
        let coatOfArms: CoatOfArms
                
        struct Name: Decodable {
            let common, official: String
        }
        
        struct Flags: Decodable {
            let png: URL
        }
        
        struct Currencies: Decodable {
            let usd: Usd

            enum CodingKeys: String, CodingKey {
                case usd = "USD"
            }
        }
        
        struct Usd: Decodable {
            let symbol, name: String
        }
        
        struct Languages: Decodable {
            let spa: String
            let fra: String
            let eng: String
            let por: String
        }
        
        struct Car: Decodable {
            let side: String
        }

        struct CoatOfArms: Decodable {
            let png: URL?
        }
    }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) throws -> Country {
        guard response.isOK else {
            throw MapperError.unsuccessfullyResponse
        }
        
        do {
            let rootArray = try JSONDecoder().decode([Root].self, from: data)
            let countries = rootArray.map { Country(commonName: $0.name.common,
                                                    officialName: $0.name.official,
                                                    capital: $0.capital.joined(separator: ","),
                                                    flagURL: $0.flags.png,
                                                    region: $0.region,
                                                    subregion: $0.subregion,
                                                    population: $0.population,
                                                    timezones: $0.timezones,
                                                    //languages: $0.languages.spa,
                                                    //currencies: "\($0.currencies.usd.symbol) \($0.currencies.usd.name)",
                                                    carDriveSide: $0.car.side,
                                                    coatOfArms: $0.coatOfArms.png,
                                                    isBookmarked: false) }
            return countries[0]
        } catch {
            throw error
        }
    }
}

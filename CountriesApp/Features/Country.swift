//
//  Country.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public struct Country: Identifiable, Hashable {
    
    public let commonName: String
    public let officialName: String
    public let capital: String
    public let flagURL: URL?
    public let region: String?
    public let subregion: String?
    public let population: Int?
    public let timezones: String?
    public let languages: String?
    public let currencies: String?
    public let carDriveSide: String?
    public let coatOfArms: URL?
    public var isBookmarked: Bool
    
    public var id: String { commonName }
    
    public init(commonName: String, officialName: String, capital: String, flagURL: URL? = nil, region: String? = nil, subregion: String? = nil, population: Int? = nil, timezones: String? = nil, languages: String? = nil, currencies: String? = nil, carDriveSide: String? = nil, coatOfArms: URL? = nil, isBookmarked: Bool) {
        self.commonName = commonName
        self.officialName = officialName
        self.capital = capital
        self.flagURL = flagURL
        self.region = region
        self.subregion = subregion
        self.population = population
        self.timezones = timezones
        self.languages = languages
        self.currencies = currencies
        self.carDriveSide = carDriveSide
        self.coatOfArms = coatOfArms
        self.isBookmarked = isBookmarked
    }
}

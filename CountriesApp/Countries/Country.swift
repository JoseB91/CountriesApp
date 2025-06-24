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
    public let flagURL: URL
    public var isFavorite: Bool
    
    public var id: String { commonName }
    
    public init(commonName: String, officialName: String, capital: String, flagURL: URL, isFavorite: Bool) {
        self.commonName = commonName
        self.officialName = officialName
        self.capital = capital
        self.flagURL = flagURL
        self.isFavorite = isFavorite
    }
}

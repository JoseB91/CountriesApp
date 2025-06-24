//
//  Country.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation

public struct Country: Identifiable {
    public var id: UUID
    public let commonName: String
    public let officialName: String
    public let capital: String
    public let flagURL: URL
    public var isFavorite: Bool
    
    public init(id: UUID = UUID(), commonName: String, officialName: String, capital: String, flagURL: URL, isFavorite: Bool) {
        self.id = id
        self.commonName = commonName
        self.officialName = officialName
        self.capital = capital
        self.flagURL = flagURL
        self.isFavorite = isFavorite
    }
}

import SwiftData

@Model
final class CountryModel {
    init(id: UUID = UUID(), commonName: String, officialName: String, capital: String, flagURL: String, isFavorite: Bool) {
        self.id = id
        self.commonName = commonName
        self.officialName = officialName
        self.capital = capital
        self.flagURL = flagURL
        self.isFavorite = isFavorite
    }
    
    @Attribute(.unique) var id: UUID = UUID()
    var commonName: String
    var officialName: String
    var capital: String
    var flagURL: String
    var isFavorite: Bool
}

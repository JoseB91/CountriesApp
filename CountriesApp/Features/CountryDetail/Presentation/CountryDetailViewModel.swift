//
//  CountryDetailViewModel.swift
//  CountriesApp
//
//  Created by Narcisa Romero on 24/6/25.
//

import Foundation
import Observation

@Observable
final class CountryDetailViewModel {
    
    var country = Country(commonName: "",
                          officialName: "",
                          capital: "",
                          flagURL: URL(string: "https://flagcdn.com/w320/tg.png")!, //TODO: Optional
                          isFavorite: false)
    var isLoading = false
    var errorMessage: ErrorModel? = nil
    
    private let countryDetailLoader: () async throws -> Country
    private let localCountriesLoader: LocalCountriesLoader
    
    init(countryDetailLoader: @escaping () async throws -> Country, localCountriesLoader: LocalCountriesLoader) {
        self.countryDetailLoader = countryDetailLoader
        self.localCountriesLoader = localCountriesLoader
    }
    
    @MainActor
    func loadCountryDetail() async {
        isLoading = true
        
        do {
            country = try await countryDetailLoader()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load countries: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
        
//    func toggleFavorite(for country: Country) {
//        if let index = countries.firstIndex(where: { $0.id == show.id }) {
//            countries[index].isFavorite.toggle()
//
//            Task {
//                do {
//                    try await localShowsLoader.saveFavorite(for: show.id)
//                } catch {
//                    await MainActor.run {
//                        self.errorMessage = ErrorModel(message: "Failed to save favorite: \(error.localizedDescription)")
//
//
//                        if let index = self.countries.firstIndex(where: { $0.id == show.id }) {
//                            self.countries[index].isFavorite.toggle()
//                        }
//                    }
//                }
//            }
//        }
//    }
}

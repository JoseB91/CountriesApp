//
//  CountriesViewModel.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation
import Observation

@Observable
final class CountriesViewModel {
    
    var countries = [Country]()
    
    var filteredCountries: [Country] {
        if searchText.isEmpty {
            return countries
        } else {
            return countries.filter { $0.commonName.contains(searchText) }
        }
    }
    
    var filteredBookmarkedCountries: [Country] {
        if searchText.isEmpty {
            return countries.filter(\.self.isBookmarked)
        } else {
            let filteredCountries = countries.filter { $0.commonName.contains(searchText) }
            return filteredCountries.filter(\.self.isBookmarked)
        }
    }

    var isLoading = false
    var errorMessage: ErrorModel? = nil
    var searchText: String = ""
    
    private let countriesViewModelRepository: CountriesViewModelRepository
    
    init(countriesViewModelRepository: CountriesViewModelRepository) {
        self.countriesViewModelRepository = countriesViewModelRepository
    }
    
    @MainActor
    func loadCountries() async {
        isLoading = true
        
        do {
            countries = try await countriesViewModelRepository.loadCountries()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load countries: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
    
}

final class MockCountriesViewModel {
    static func mockCountry() -> Country {
        return Country(commonName: "Togo",
                       officialName: "Togolese Republic",
                       capital: "Lomé",
                       flagURL: URL(string: "https://flagcdn.com/w320/tg.png")!,
                       isBookmarked: false)
    }
    
    static func mockCountriesLoader() async throws -> [Country] {
        return [mockCountry()]
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

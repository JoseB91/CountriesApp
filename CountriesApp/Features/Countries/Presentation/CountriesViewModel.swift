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
    var isLoading = false
    var errorMessage: ErrorModel? = nil
    var searchText: String = ""
    
    private let countriesLoader: () async throws -> [Country]
    private let isFavoriteViewModel: Bool
    
    init(countriesLoader: @escaping () async throws -> [Country], isFavoriteViewModel: Bool) {
        self.countriesLoader = countriesLoader
        self.isFavoriteViewModel = isFavoriteViewModel
    }
    
    @MainActor
    func loadCountries() async {
        if isFavoriteViewModel {
            isLoading = true
            
            do {
                countries = try await countriesLoader()
            } catch {
                errorMessage = ErrorModel(message: "Failed to load favorite countries: \(error.localizedDescription)")
            }
            
            isLoading = false
        } else {
            isLoading = true
            
            do {
                countries = try await countriesLoader()
            } catch {
                errorMessage = ErrorModel(message: "Failed to load countries: \(error.localizedDescription)")
            }
        
            isLoading = false
        }
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

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
        
//    func toggleFavorite(for show: Country) {
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

final class MockCountriesViewModel {
    static func mockCountry() -> Country {
        return Country(commonName: "Togo",
                       officialName: "Togolese Republic",
                       capital: "Lomé",
                       flagURL: URL(string: "https://flagcdn.com/w320/tg.png")!,
                       isFavorite: false)
    }
    
    static func mockCountriesLoader() async throws -> [Country] {
        return [mockCountry()]
    }
    
    static func mockLocalCountriesLoader() -> LocalCountriesLoader {
        return LocalCountriesLoader(store: MockCountryStore(), currentDate: Date.init)
    }
}

final class MockCountryStore: CountriesStore {
    func deleteCache() async throws {
    }
    
    func insert(_ countries: [LocalCountry], timestamp: Date) async throws {
    }
    
    func retrieve() async throws -> CachedCountries? {
        return nil
    }
    
    func insertFavorite(with flagURL: URL) async throws {
    }
}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

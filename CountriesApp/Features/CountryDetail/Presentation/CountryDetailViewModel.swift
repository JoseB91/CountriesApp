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
                          isBookmarked: false)
    var isLoading = false
    var errorMessage: ErrorModel? = nil
    
    private let countryDetailRepository: CountryRepository
    private let localCountriesLoader: LocalCountriesLoader
    
    init(countryDetailRepository: CountryRepository, localCountriesLoader: LocalCountriesLoader) {
        self.countryDetailRepository = countryDetailRepository
        self.localCountriesLoader = localCountriesLoader
    }
    
    @MainActor
    func loadCountryDetail() async {
        isLoading = true
        
        do {
            country = try await countryDetailRepository.loadCountry()
        } catch {
            errorMessage = ErrorModel(message: "Failed to load country detail: \(error.localizedDescription)")
        }
        
        isLoading = false
    }
        
    func toggleBookmark(for flagURL: URL) {
        country.isBookmarked.toggle()
        
        Task {
            do {
                try await localCountriesLoader.saveBookmark(with: flagURL)
            } catch {
                await MainActor.run {
                    self.errorMessage = ErrorModel(message: "Failed to save favorite: \(error.localizedDescription)")
                                        
                    country.isBookmarked.toggle()
                }
            }
        }
    }
}

final class MockCountryDetailViewModel {
    static func mockCountryDetail() -> Country {
        return Country(commonName: "Togo",
                    officialName: "Togolese Republic",
                    capital: "Lomé",
                    flagURL: URL(string: "https://flagcdn.com/w320/tg.png")!,
                    region: "Africa",
                    subregion: "Western Africa",
                    population: 8278737,
                    timezones: "UTC",
                    carDriveSide: "right",
                    coatOfArms: URL(string: "https://mainfacts.com/media/images/coats_of_arms/tg.png")!,
                    isBookmarked: false)
    }
    
    static func mockCountryDetailLoader() async throws -> (Country, Bool?) {
        return (mockCountryDetail(), false)
    }
    
    static func mockLocalCountriesLoader() -> LocalCountriesLoader {
        return LocalCountriesLoader(store: MockCountryStore(), currentDate: Date.init)
    }
}

final class MockCountryStore: CountriesStore {
    func retrieveBookmark(with flagURL: URL) async throws -> Bool? {
        false
    }
    
    func deleteCache() async throws {
    }
    
    func insert(_ countries: [LocalCountry], timestamp: Date) async throws {
    }
    
    func retrieveAll() async throws -> CachedCountries? {
        return nil
    }
    
    func insertBookmark(with flagURL: URL) async throws {
    }
}

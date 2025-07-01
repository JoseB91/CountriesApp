//
//  Composer.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import SwiftUI
import CoreData

class Composer {
    private let baseURL: URL
    private let httpClient: URLSessionHTTPClient
    private let localCountriesLoader: LocalCountriesLoader
    
    init(baseURL: URL, httpClient: URLSessionHTTPClient, localCountriesLoader: LocalCountriesLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCountriesLoader = localCountriesLoader
    }
    
    static func makeComposer() -> Composer {
        
        let baseURL = URL(string: "https://restcountries.com/v3.1/")!
        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let store = makeStore()
        let localCountriesLoader = LocalCountriesLoader(store: store, currentDate: Date.init)
        
        return Composer(baseURL: baseURL,
                        httpClient: httpClient,
                        localCountriesLoader: localCountriesLoader)
    }
    
    private static func makeStore() -> CountriesStore {
        do {
            return try CoreDataCountriesAppStore(
                storeURL: NSPersistentContainer
                    .defaultDirectoryURL()
                    .appendingPathComponent("countries-app-store.sqlite"))
        } catch {
            return InMemoryStore()
        }
    }

    
    func composeCountriesViewModel() -> CountriesViewModel {
        let repository = CountriesRepository(
            baseURL: baseURL,
            httpClient: httpClient,
            localCountriesLoader: localCountriesLoader
        )
        
        return CountriesViewModel(countriesViewModelRepository: repository)
    }

    
    func composeCountryDetailViewModel(for name: String) -> CountryDetailViewModel {
        let repository = CountryRepository(
            baseURL: baseURL,
            httpClient: httpClient,
            localCountriesLoader: localCountriesLoader,
            name: name)
                
        return CountryDetailViewModel(countryDetailRepository: repository,
                                      localCountriesLoader: localCountriesLoader)
    }
    
    
    func composeFavoriteCountriesViewModel() -> CountriesViewModel {
        let repository = FavoriteCountriesRepository(
            localFavoritesLoader: localCountriesLoader
        )
        
        return CountriesViewModel(countriesViewModelRepository: repository)
    }
}

protocol CountriesViewModelRepository {
    func loadCountries() async throws -> [Country]
}

protocol CountryDetailRepository {
    func loadCountry() async throws -> Country
}


final class CountriesRepository: CountriesViewModelRepository {
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let localCountriesLoader: LocalCountriesLoader

    init(baseURL: URL, httpClient: HTTPClient, localCountriesLoader: LocalCountriesLoader) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCountriesLoader = localCountriesLoader
    }

    func loadCountries() async throws -> [Country] {
        do {
            return try await localCountriesLoader.load()
        } catch {
            let url = CountriesEndpoint.getCountries.url(baseURL: baseURL)
            let (data, response) = try await httpClient.get(from: url)
            let countries = try CountriesMapper.map(data, from: response)

            do {
                try await localCountriesLoader.save(countries)
            } catch {
                print("Error saving countries locally: \(error)")
            }

            let sortedCountries = countries.sorted { $0.commonName < $1.commonName }
            return sortedCountries
        }
    }
}

final class FavoriteCountriesRepository: CountriesViewModelRepository {
    private let localFavoritesLoader: LocalCountriesLoader

    init(localFavoritesLoader: LocalCountriesLoader) {
        self.localFavoritesLoader = localFavoritesLoader
    }

    func loadCountries() async throws -> [Country] {
        let favorites = try await localFavoritesLoader.load()
        return favorites.sorted { $0.commonName < $1.commonName }
    }
}

final class CountryRepository: CountryDetailRepository {
    private let baseURL: URL
    private let httpClient: HTTPClient
    private let localCountriesLoader: LocalCountriesLoader
    private let name: String

    init(baseURL: URL, httpClient: HTTPClient, localCountriesLoader: LocalCountriesLoader, name: String) {
        self.baseURL = baseURL
        self.httpClient = httpClient
        self.localCountriesLoader = localCountriesLoader
        self.name = name
    }

    func loadCountry() async throws -> Country {
        let url = CountryDetailEndpoint.getCountryDetail(name: name).url(baseURL: baseURL)
        let (data, response) = try await httpClient.get(from: url)
        var country = try CountryDetailMapper.map(data, from: response)
        
        guard let flagURL = country.flagURL else { return country }
        
        let isBookmarked = try? await localCountriesLoader.loadBookmark(with: flagURL)
        country.isBookmarked = isBookmarked ?? false
                       
        return country
    }
}

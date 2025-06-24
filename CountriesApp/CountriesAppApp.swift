//
//  CountriesAppApp.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import SwiftUI

@main
struct CountriesAppApp: App {
    
    private let composer: Composer
    
    init() {
        self.composer = Composer.makeComposer()
    }
    
    @State private var selectedTab = 0
    @State private var countriesNavigationPath = NavigationPath()
    @State private var savedNavigationPath = NavigationPath()
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                // Countries Tab
                NavigationStack(path: $countriesNavigationPath) {
                    CountriesView(countriesViewModel: composer.composeCountriesViewModel(),
                                  navigationPath: $countriesNavigationPath,
                                  isFavoriteView: false)
                    //                    .navigationDestination(for: Show.self) { show in
                    //                        CountryDetailView(countryDetailViewModel: composer.composeCountryDetailViewModel(for: country),
                    //                                       navigationPath: countriesNavigationPath,
                    //                                       show: show)
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(0)
                
                // Saved Tab
                NavigationStack(path: $savedNavigationPath) {
                    CountriesView(countriesViewModel: composer.composeFavoriteCountriesViewModel(),
                                  navigationPath: $savedNavigationPath,
                                  isFavoriteView: true)
                }
                .tabItem {
                    Label("Saved", systemImage: "star.fill")
                }
                .tag(1)
                
            }
        }
    }
}


import Foundation
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
        let countriesLoader: () async throws -> [Country] = { [baseURL, httpClient, localCountriesLoader] in
            
            do {
                return try await localCountriesLoader.load()
            } catch {
                
                let url = CountriesEndpoint.getCountries.url(baseURL: baseURL)
                let (data, response) = try await httpClient.get(from: url)
                let countries = try CountriesMapper.map(data, from: response)
                
                do {
                    try await localCountriesLoader.save(countries)
                } catch {
                    print(error)
                }
                
                return countries
            }
        }
        
        return CountriesViewModel(countriesLoader: countriesLoader,
                                  isFavoriteViewModel: false)
    }
    
    //    func composeCountryDetailViewModel(for country: Country) -> CountryDetailViewModel {
    //        let episodesLoader: () async throws -> [Episode] = { [baseURL, httpClient] in
    //
    //            let url = EpisodesEndpoint.getEpisodes(showId: show.id).url(baseURL: baseURL)
    //            let (data, response) = try await httpClient.get(from: url)
    //            let episodes = try EpisodesMapper.map(data, from: response)
    //
    //            return episodes
    //        }
    //
    //        return CountryDetailViewModel(episodesLoader: episodesLoader)
    //    }
    
    
    func composeFavoriteCountriesViewModel() -> CountriesViewModel {
        let countriesLoader: () async throws -> [Country] = { [localCountriesLoader] in
            return try await localCountriesLoader.load()
        }
        
        return CountriesViewModel(countriesLoader: countriesLoader,
                                  isFavoriteViewModel: true)
    }
}

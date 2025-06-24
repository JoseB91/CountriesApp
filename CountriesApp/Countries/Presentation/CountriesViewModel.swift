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
    
    //private let countriesLoader: () async throws -> [Country]
    //private let isFavoriteViewModel: Bool
    
//    init(countriesLoader: @escaping () async throws -> [Country], isFavoriteViewModel: Bool) {
//        self.countriesLoader = countriesLoader
//        self.isFavoriteViewModel = isFavoriteViewModel
//    }
    
    @MainActor
    func loadCountries() async {
//        if isFavoriteViewModel {
//            isLoading = true
//            
//            do {
//                countries = try await countriesLoader()
//            } catch {
//                errorMessage = ErrorModel(message: "Failed to load favorite countries: \(error.localizedDescription)")
//            }
//            
//            isLoading = false
//        } else {
            isLoading = true
            
            do {
                let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
                let baseURL = URL(string: "https://restcountries.com/v3.1/")!
                let url = CountriesEndpoint.getCountries.url(baseURL: baseURL)
                let (data, response) = try await httpClient.get(from: url)
                countries = try CountriesMapper.map(data, from: response)
                //countries = try await countriesLoader()
            } catch {
                errorMessage = ErrorModel(message: "Failed to load countries: \(error.localizedDescription)")
            }
        
            isLoading = false
        //}
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
    
//    static func mockShowsLoader(_ page: Int, _ append: Bool) async throws -> [Country] {
//        return [mockShow()]
//    }
//    
//    static func mockLocalShowsLoader() -> LocalShowsLoader {
//        return LocalShowsLoader(store: MockShowStore(), currentDate: Date.init)
//    }
}

//final class MockShowStore: ShowsStore {
//    func deleteCache() async throws {
//    }
//    
//    func insert(_ countries: [LocalShow], timestamp: Date) async throws {
//    }
//    
//    func retrieve() async throws -> CachedShows? {
//        return nil
//    }
//    
//    func insertFavorite(for showId: Int) async throws {
//    }
//}

struct ErrorModel: Identifiable {
    let id = UUID()
    let message: String
}

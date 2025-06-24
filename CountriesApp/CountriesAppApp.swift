//
//  CountriesAppApp.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import SwiftUI
import SwiftData

@main
struct CountriesAppApp: App {
    var body: some Scene {
        WindowGroup {
            CountriesView()
        }
    }
}


import Foundation
import SwiftUI
import CoreData

//class Composer {
//    private let baseURL: URL
//    private let httpClient: URLSessionHTTPClient
//    private let localCountriesLoader: LocalCountriesLoader
//
//    init(baseURL: URL, httpClient: URLSessionHTTPClient, localCountriesLoader: LocalCountriesLoader) {
//        self.baseURL = baseURL
//        self.httpClient = httpClient
//        self.localCountriesLoader = localCountriesLoader
//    }
//    
//    static func makeComposer() -> Composer {
//        
//        let baseURL = URL(string: "https://restcountries.com/v3.1/")!
//        let httpClient = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
//        let store = makeStore()
//        let localCountriesLoader = LocalCountriesLoader(store: store, currentDate: Date.init)
//                
//        return Composer(baseURL: baseURL,
//                        httpClient: httpClient,
//                        localCountriesLoader: localCountriesLoader)
//    }
//    
//    private static func makeStore() -> CountriesStore {
//        do {
//            return try CoreDataTVMazeStore(
//                storeURL: NSPersistentContainer
//                    .defaultDirectoryURL()
//                    .appendingPathComponent("tvmaze-store.sqlite"))
//        } catch {
//            return InMemoryStore()
//        }
//    }
//
//    func composeShowsViewModel() -> ShowsViewModel {
//        let showsLoader: (_ page: Int, _ append: Bool) async throws -> [Show] = { [baseURL, httpClient, localCountriesLoader] page, append in
//            
//            if !append && page == 0 {
//                do {
//                    return try await localCountriesLoader.load()
//                } catch {
//                    let url = ShowsEndpoint.getShows(page: page).url(baseURL: baseURL)
//                    let (data, response) = try await httpClient.get(from: url)
//                    let shows = try ShowsMapper.map(data, from: response)
//                    
//                    do {
//                        try await localCountriesLoader.save(shows)
//                    } catch {
//                        print(error)
//                    }
//                    
//                    return shows
//                }
//            } else {
//                let url = ShowsEndpoint.getShows(page: page).url(baseURL: baseURL)
//                let (data, response) = try await httpClient.get(from: url)
//                let newShows = try ShowsMapper.map(data, from: response)
//                
//                do {
//                    try await localCountriesLoader.save(newShows)
//                } catch {
//                    print(error)
//                }
//                                
//                return try await localCountriesLoader.load()
//            }
//        }
//        
//        return ShowsViewModel(showsLoader: showsLoader,
//                              localCountriesLoader: localCountriesLoader,
//                              isFavoriteViewModel: false)
//    }
//
//    func composeShowDetailViewModel(for show: Show) -> ShowDetailViewModel {
//        let episodesLoader: () async throws -> [Episode] = { [baseURL, httpClient] in
//            
//            let url = EpisodesEndpoint.getEpisodes(showId: show.id).url(baseURL: baseURL)
//            let (data, response) = try await httpClient.get(from: url)
//            let episodes = try EpisodesMapper.map(data, from: response)
//
//            return episodes
//        }
//        
//        return ShowDetailViewModel(episodesLoader: episodesLoader)
//    }
//    
//    func composePeopleViewModel() -> PeopleViewModel {
//        let peopleLoader: () async throws -> [Person] = { [baseURL, httpClient] in
//            
//            let url = PeopleEndpoint.getPeople(page: 0).url(baseURL: baseURL)
//            let (data, response) = try await httpClient.get(from: url)
//            let people = try PeopleMapper.map(data, from: response)
//
//            return people
//        }
//        
//        return PeopleViewModel(peopleLoader: peopleLoader)
//    }
//    
//    func composePersonDetailViewModel(for person: Person) -> PersonDetailViewModel {
//        let personShowsLoader: () async throws -> [PersonShow] = { [baseURL, httpClient] in
//            
//            let url = PersonShowsEndpoint.getPersonShows(personId: person.id).url(baseURL: baseURL)
//            let (data, response) = try await httpClient.get(from: url)
//            let personShows = try PersonShowsMapper.map(data, from: response)
//
//            return personShows
//        }
//        
//        return PersonDetailViewModel(personShowsLoader: personShowsLoader)
//    }
//    
//    func composePersonShowViewModel(with url: URL) -> PersonShowViewModel {
//        let personShowLoader: () async throws -> Show = { [httpClient] in
//            
//            let (data, response) = try await httpClient.get(from: url)
//            let show = try ShowsMapper.mapPersonShow(data, from: response)
//
//            return show
//        }
//        
//        return PersonShowViewModel(personShowLoader: personShowLoader)
//    }
//    
//    func composeFavoriteShowsViewModel() -> ShowsViewModel {
//        let showsLoader: (_ page: Int, _ append: Bool) async throws -> [Show] = { [localCountriesLoader] _, _ in
//            return try await localCountriesLoader.load()
//        }
//        
//        return ShowsViewModel(showsLoader: showsLoader,
//                              localCountriesLoader: localCountriesLoader,
//                              isFavoriteViewModel: true)
//    }
//}

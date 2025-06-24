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

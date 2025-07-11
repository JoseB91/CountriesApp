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
                                  isBookmarkView: false)
                    .navigationDestination(for: String.self) { name in
                        CountryDetailView(countryDetailViewModel: composer.composeCountryDetailViewModel(for: name))
                    }
                }
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(0)
                
                // Saved Tab
                NavigationStack(path: $savedNavigationPath) {
                    CountriesView(countriesViewModel: composer.composeFavoriteCountriesViewModel(),
                                  navigationPath: $savedNavigationPath,
                                  isBookmarkView: true)
                }
                .tabItem {
                    Label("Saved", systemImage: "star.fill")
                }
                .tag(1)
                
            }
        }
    }
}

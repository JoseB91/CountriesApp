//
//  CountriesView.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation
import SwiftUI
//TODO: UpdateUI
//TODO: Add DetailView with button to bookmark
//TODO: Implement save with rest api
struct CountriesView: View {
    @State var countriesViewModel: CountriesViewModel
    @Binding var navigationPath: NavigationPath
    let isFavoriteView: Bool

    @State private var searchText = ""
    
    var countries: [Country] {
        if searchText.isEmpty {
            let bookmarkedCountries = countriesViewModel.countries.filter(\.self.isFavorite)
            return isFavoriteView ? bookmarkedCountries : countriesViewModel.countries
        } else {
            let filteredCountries = countriesViewModel.countries.filter { $0.commonName.contains(searchText) }
            let bookmarkedFilteredShows = filteredCountries.filter(\.self.isFavorite)
            return isFavoriteView ? bookmarkedFilteredShows : filteredCountries
        }
    }
    
    var body: some View {
        ZStack {
            if isFavoriteView && countriesViewModel.countries.filter(\.self.isFavorite).isEmpty {
                Text("Your bookmarked countries will appear here")
            } else if countriesViewModel.isLoading {
                ProgressView("Loading countries...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        ForEach(countries) { country in
                            Button {
                                navigationPath.append(country.officialName)
                            } label: {
                                CountryCardView(country: country,
                                             isFavoriteView: isFavoriteView)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    .searchable(text: $searchText, prompt: "Search")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await countriesViewModel.loadCountries()
        }
        .navigationTitle(isFavoriteView ? "Saved" : "Search")
        .alert(item: $countriesViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

#Preview {
    let countriesViewModel = CountriesViewModel(
        countriesLoader: MockCountriesViewModel.mockCountriesLoader,
        isFavoriteViewModel: false
    )
    
    CountriesView(countriesViewModel: countriesViewModel,
                  navigationPath: .constant(NavigationPath()),
                  isFavoriteView: false)
}

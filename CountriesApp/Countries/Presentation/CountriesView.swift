//
//  CountriesView.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation
import SwiftUI

struct CountriesView: View {
    @State var countriesViewModel: CountriesViewModel = CountriesViewModel()
    //@Binding var navigationPath: NavigationPath
    let isFavoriteView: Bool = false

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
//        ZStack {
//            if isFavoriteView && countriesViewModel.countries.filter(\.self.isFavorite).isEmpty {
//                Text("Your bookmarked countries will appear here")
//            } else if countriesViewModel.isLoading {
//                ProgressView("Loading countries...")
//                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
//            } else {
//                ScrollView {
//                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
//                        ForEach(countries) { country in
//                            Button {
//                                //navigationPath.append(show)
//                            } label: {
//                                CountryCardView(country: country,
//                                             isFavoriteView: isFavoriteView)
//                            }
//                            .buttonStyle(PlainButtonStyle())
//                        }
//                    }
//                    .padding()
//                    .searchable(text: $searchText, prompt: "Search countries")
//                }
//                .background(Color(.systemGray6))
//            }
//        }
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                ForEach(countries) { country in
                    Button {
                        //navigationPath.append(show)
                    } label: {
                        CountryCardView(country: country)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
            .searchable(text: $searchText, prompt: "Search countries")
        }
        .background(Color(.systemGray6))
        .task {
            await countriesViewModel.loadCountries()
        }
        .navigationTitle(isFavoriteView ? "Favorites" : "Countries")
        .alert(item: $countriesViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}

//#Preview {
//    let countriesViewModel = ShowsViewModel(showsLoader: MockShowsViewModel.mockShowsLoader,
//                                        localShowsLoader: MockShowsViewModel.mockLocalShowsLoader(),
//                                        isFavoriteViewModel: false)
//    
//    ShowsView(countriesViewModel: countriesViewModel,
//              navigationPath: .constant(NavigationPath()),
//              isFavoriteView: false)
//}

//
//  CountriesView.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation
import SwiftUI

struct CountriesView: View {
    @State var countriesViewModel: CountriesViewModel
    @Binding var navigationPath: NavigationPath
    let isBookmarkView: Bool
        
    var body: some View {
        ZStack {
            if isBookmarkView && countriesViewModel.countries.filter(\.self.isBookmarked).isEmpty {
                Text("Your bookmarked countries will appear here")
            } else if countriesViewModel.isLoading {
                ProgressView("Loading countries...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else {
                ScrollView {
                    ForEach(isBookmarkView ? countriesViewModel.filteredBookmarkedCountries : countriesViewModel.filteredCountries) { country in
                        Button {
                            if !isBookmarkView {
                                navigationPath.append(country.officialName)
                            }
                        } label: {
                            CountryCardView(country: country)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    .padding()
                    .searchable(text: $countriesViewModel.searchText, prompt: "Search")
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await countriesViewModel.loadCountries()
        }
        .navigationTitle(isBookmarkView ? "Saved" : "Search")
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
//    let countriesViewModel = CountriesViewModel(
//        countriesLoader: MockCountriesViewModel.mockCountriesLoader,
//        isFavoriteViewModel: false
//    )
    
//    NavigationStack {
//        CountriesView(countriesViewModel: countriesViewModel,
//                      navigationPath: .constant(NavigationPath()),
//                      isBookmarkView: false)
//    }
}

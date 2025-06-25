//
//  CountryDetailView.swift
//  CountriesApp
//
//  Created by Narcisa Romero on 24/6/25.
//

import SwiftUI

struct CountryDetailView: View {
    @State var countryDetailViewModel: CountryDetailViewModel

    var body: some View {
        VStack(alignment: .leading) {
            if let flagURL = countryDetailViewModel.country.flagURL {
                ImageView(url: flagURL)
            }
            
            Text(countryDetailViewModel.country.commonName)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .cornerRadius(8)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    toggleBookmark()
                }) {
                    Image(systemName: countryDetailViewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                        .foregroundColor(.blue)
                }
            }
        }
        .task {
            await countryDetailViewModel.loadCountryDetail()
        }
        .alert(item: $countryDetailViewModel.errorMessage) { error in
            Alert(
                title: Text("Error"),
                message: Text(error.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func toggleBookmark() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let flagURL = countryDetailViewModel.country.flagURL {
                countryDetailViewModel.toggleBookmark(for: flagURL)
            }
        }
    }
}

#Preview {
    let countryDetailViewModel = CountryDetailViewModel(
        countryDetailLoader: MockCountryDetailViewModel.mockCountryDetailLoader,
        localCountriesLoader: MockCountryDetailViewModel.mockLocalCountriesLoader()
    )
    CountryDetailView(countryDetailViewModel: countryDetailViewModel)
}

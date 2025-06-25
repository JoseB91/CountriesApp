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
        ScrollView {
            VStack(spacing: 16) {
                if let flagURL = countryDetailViewModel.country.flagURL {
                    ImageView(url: flagURL)
                        .frame(height: 150)
                        .clipped()
                }
                
                // Country name card
                VStack {
                    Text(countryDetailViewModel.country.commonName)
                        .font(.title2.bold())
                        .foregroundStyle(.primary)
                    Text(countryDetailViewModel.country.officialName)
                        .font(.subheadline)
                        .foregroundStyle(.primary)
                }
                .cardStyle()

                VStack(spacing: 16) {
                    // Region, Subregion, Capital
                    HStack(spacing: 12) {
                        InfoColumn(title: "Region",
                                   value: countryDetailViewModel.country.region ?? "")
                        Divider()
                            .frame(width: 2, height: 30)
                            .background(Color(UIColor.lightGray))
                        
                        InfoColumn(title: "Subregion",
                                   value: countryDetailViewModel.country.subregion ?? "")
                        Divider()
                            .frame(width: 2, height: 30)
                            .background(Color(UIColor.lightGray))
                        
                        InfoColumn(title: "Capital", value: countryDetailViewModel.country.capital)
                    }
                    .cardStyle()
                    
                    // Timezones and Population
                    HStack(spacing: 16) {
                        if let timezones = countryDetailViewModel.country.timezones {
                            CountryInfoCard(title: "Timezone(s)",
                                            value: timezones)
                        }
                        
                        if let population = countryDetailViewModel.country.population {
                            CountryInfoCard(title: "Population",
                                            value: NumberFormatter.localizedString(from: NSNumber(value: population),
                                                                                   number: .decimal))
                        }
                    }
                    
                    // Car Drive Side and Coat of Arms
                    HStack(spacing: 16) {
                        if let carDriveSide = countryDetailViewModel.country.carDriveSide {
                            DrivingSideCard(carDriveSide: carDriveSide)
                        }
                        if let coatOfArmsURL = countryDetailViewModel.country.coatOfArms {
                            CoatOfArmsCard(url: coatOfArmsURL)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
            .padding()
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
    }
    
    private func toggleBookmark() {
        withAnimation(.easeInOut(duration: 0.2)) {
            if let flagURL = countryDetailViewModel.country.flagURL {
                countryDetailViewModel.toggleBookmark(for: flagURL)
            }
        }
    }
}

struct InfoColumn: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack {
            Text(title)
                .font(.subheadline).bold()
            Spacer()
            Text(value)
                .font(.footnote)
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }
}

struct DisabledText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .foregroundColor(.gray)
    }
}

struct EnabledText: View {
    let text: String
    
    var body: some View {
        Text(text)
            .font(.footnote)
            .bold()
    }
}

#Preview {
    let countryDetailViewModel = CountryDetailViewModel(
        countryDetailLoader: MockCountryDetailViewModel.mockCountryDetailLoader,
        localCountriesLoader: MockCountryDetailViewModel.mockLocalCountriesLoader()
    )
    NavigationStack {
        CountryDetailView(countryDetailViewModel: countryDetailViewModel)
    }
}

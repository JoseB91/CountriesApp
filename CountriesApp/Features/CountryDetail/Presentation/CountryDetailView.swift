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
            ImageView(url: countryDetailViewModel.country.flagURL)
            
            Text(countryDetailViewModel.country.commonName)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
        }
        .cornerRadius(8)
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

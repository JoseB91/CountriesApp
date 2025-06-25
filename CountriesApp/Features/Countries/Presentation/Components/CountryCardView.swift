//
//  CountryCardView.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import SwiftUI

struct CountryCardView: View {
    let country: Country
    
    var body: some View {
        HStack(spacing: 16) {
            
            // Flag section
            if let flagURL = country.flagURL {
                ImageView(url: flagURL)
                    .frame(width: 80, height: 80)
            }
            
            // Country info section
            VStack(alignment: .leading, spacing: 2) {
                Text(country.commonName)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(country.officialName)
                    .font(.callout)
                    .foregroundColor(.primary)
                
                Text(country.capital)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Bookmark section
            VStack {
                Image(systemName: country.isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundStyle(.blue)
                Spacer()
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        
                )
                .shadow(color: .black.opacity(0.2), radius: 12, x: 6, y: 6)
        )
    }
}

#Preview {
    let country = MockCountriesViewModel.mockCountry()
    CountryCardView(country: country)
}

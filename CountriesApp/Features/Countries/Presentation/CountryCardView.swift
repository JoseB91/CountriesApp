//
//  CountryCardView.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import SwiftUI

struct CountryCardView: View {
    let country: Country
    let isBookmarkView: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            if let flagURL = country.flagURL {
                ImageView(url: flagURL)
            }
            
            Text(country.commonName)
                .font(.headline)
                .foregroundColor(.primary)
                .lineLimit(1)
                .padding(.init(top: 4, leading: 4, bottom: 4, trailing: 4))
            
//            HStack(spacing: 12) {
//                if !isBookmarkView {
//                    Button(action: {
//                        showsViewModel.toggleFavorite(for: show)
//                    }) {
//                        Image(systemName: show.isBookmarked ? "heart.fill" : "heart")
//                            .foregroundColor(show.isBookmarked ? .red : .secondary)
//                    }
//                }
//            }
        }
        .cornerRadius(8)
    }
}


struct ImageView: View {
    let url: URL
    
    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    )
                
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                
            case .failure:
                Rectangle()
                    .foregroundColor(.secondary)
                    .aspectRatio(contentMode: .fit)
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.gray)
                    )
                
            @unknown default:
                EmptyView()
            }
        }
        .cornerRadius(6)
        .shadow(radius: 2)
    }
}

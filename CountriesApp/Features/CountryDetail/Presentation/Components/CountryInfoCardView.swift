//
//  CountryInfoCardView.swift
//  CountriesApp
//
//  Created by José Briones on 24/6/25.
//

import SwiftUI

struct CountryInfoCard: View {
    let title : String
    let value : String
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.subheadline.bold())
            Text(value)
                .font(.footnote)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardStyle()
    }
}

#Preview {
    CountryInfoCard(title: "Population",
                    value: "329,484,123")
}

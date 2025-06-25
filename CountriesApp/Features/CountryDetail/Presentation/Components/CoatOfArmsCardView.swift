//
//  CoatOfArmsCardView.swift
//  CountriesApp
//
//  Created by José Briones on 24/6/25.
//

import SwiftUI

struct CoatOfArmsCard: View {
    let url: URL
    
    var body: some View {
        VStack(spacing: 8) {
            Text("Coat of Arms")
                .font(.subheadline).bold()
           ImageView(url: url)
                .frame(height: 40)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardStyle()
    }
}

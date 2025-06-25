//
//  FlagAndNameView.swift
//  CountriesApp
//
//  Created by José Briones on 25/6/25.
//

import SwiftUI

struct FlagAndNameView: View {
    let url: URL
    let commonName: String
    let officialName: String
    
    var body: some View {
        //GeometryReader { geometry in
            ZStack {
                ImageView(url: url)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                VStack {
                    Spacer()
                        .frame(height: 220)
                    VStack {
                        Text(commonName)
                            .font(.title3.bold())
                        Text(officialName)
                            .font(.subheadline)
                    }
                    .padding()
                    .background(Color(UIColor.secondarySystemBackground))
                    .cornerRadius(12)
                    .shadow(radius: 4)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                }
            }
        //}
    }
}

#Preview {
    NavigationStack {
        FlagAndNameView(url: URL(string: "https://flagcdn.com/w320/tg.png")!,
                        commonName: "Togo",
                        officialName: "Togolese Republic")
    }
}

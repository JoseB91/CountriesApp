//
//  DrivingSideCardView.swift
//  CountriesApp
//
//  Created by José Briones on 24/6/25.
//

import SwiftUI

struct DrivingSideCard: View {
    let carDriveSide: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Car Drive Side")
                .font(.subheadline).bold()

            HStack {
                if carDriveSide == "left"  {
                    EnabledText(text: "LEFT")
                } else {
                    DisabledText(text: "LEFT")
                }
                
                Image(systemName: "car.fill")

                if carDriveSide == "right" {
                    EnabledText(text: "RIGHT")
                } else {
                    DisabledText(text: "RIGHT")
                }
            }

            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .cardStyle()
    }
}

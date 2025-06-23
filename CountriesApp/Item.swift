//
//  Item.swift
//  CountriesApp
//
//  Created by José Briones on 23/6/25.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

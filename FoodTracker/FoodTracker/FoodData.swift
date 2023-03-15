//
//  FoodData.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import Foundation

struct FoodData: Codable, Identifiable {
    var idData = UUID()
    var id: Int
    var food: String
    var amount: String
    var expirationDay: Int
}


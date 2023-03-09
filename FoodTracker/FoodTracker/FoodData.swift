//
//  FoodData.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import Foundation

struct FoodData: Codable {
    var id: String
    var food: String
    var amount: String
    var expirationDay: Int
}

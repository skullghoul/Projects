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
    var amountofDaysTillExpiration: Int
    var calendarDate: Date
    var food: String
    var amount: String
    var expirationNameValue: Int
}


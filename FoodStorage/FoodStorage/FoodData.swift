//
//  FoodData.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import Foundation


struct FoodData: Codable, Identifiable, Equatable {
    var uuid = UUID()
    var id: Int
    var amountofDaysTillExpiration: Int
    var calendarDate: Date
    var food: String
    var amount: String
    var expirationNameValue: Int
    
    init(idData: UUID = UUID(), id: Int = 0, amountofDaysTillExpiration: Int = 0, calendarDate: Date = Date.now, food: String = "", amount: String = "", expirationNameValue: Int = 0) {
//        self.idData = idData
        self.id = id
        self.amountofDaysTillExpiration = amountofDaysTillExpiration
        self.calendarDate = calendarDate
        self.food = food
        self.amount = amount
        self.expirationNameValue = expirationNameValue
    }
    
    static func ==(lhs: FoodData, rhs: FoodData) -> Bool {
        return lhs.id == rhs.id
    }
}
 

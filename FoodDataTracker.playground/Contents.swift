import UIKit

struct FoodData: Codable {
    var id: String
    var food: String
    var amount: String
    var expirationDay: Int
}

//MARK: This goes on the viewController

var food = [FoodData]()
var dateValue = 1

func dateAmount() {
    var expiration = "fresh"
    
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "MM/dd/yyyy"
    print(dateFormatter.string(from: date))
    
    var future = dateFormatter.date(from: "03/20/2023")
    let timeDiff = future?.timeIntervalSinceNow
    let daysDiff = Int(timeDiff! / (24 * 60 * 60) + 1)
    
    
    dateValue = daysDiff
    
    if dateValue == 0 {
        expiration = "expired"
    } else if dateValue <= 7 {
        expiration = "going bad soon"
    } else {
        expiration = "fresh"
    }
    
    let item1 = FoodData(id: expiration, food: "foodItem.text", amount: "3", expirationDay: dateValue)
    let item2 = FoodData(id: expiration, food: "foodItem.text", amount: "3", expirationDay: 5)
    let item3 = FoodData(id: expiration, food: "foodItem.text", amount: "3", expirationDay: 0)
        
    var data: [FoodData] = [item1, item2, item3, FoodData(id: "food", food: "name3", amount: "2", expirationDay: 13)]
//    let foodInfo = FoodData(id: expiration, food: "foodItem.text", amount: "3", expirationDay: dateValue)
    food.append(contentsOf: data)
    
    let dictionary = Dictionary(grouping: food, by: { $0.id })
        print(dictionary)
    
    print(food)
}

dateAmount()



//

//
//dateFormatter.dateFormat = "MM/dd/yyyy"




//var items = FoodData(id: 2, food: "name15", amount: "5", expirationDay: 10)
//
//var item1 = FoodData(id: 1, food: "name1", amount: "1", expirationDay: 15)
//var item3 = FoodData(id: 1, food: "namer", amount: "4", expirationDay: 20)
//var item2 = FoodData(id: 2, food: "name2", amount: "2", expirationDay: 4)


//var data: [FoodData] = [item1, item2, item3, FoodData(id: "food", food: "name3", amount: "2", expirationDay: 13)]










//struct Item {
//    let name: String
//    let date: Date
//}
//
//var item1 = Item(name: "Name1", date: Date().addingTimeInterval(1004003))
//var item2 = Item(name: "Name2", date: Date().addingTimeInterval(10548489))
//let items: [Item] = [item1, item2, Item(name: "Name3", date: Date().addingTimeInterval(1004059))]
//
//// map to dictionary where the key is the month
//
//let dictionary = Dictionary(grouping: items) { item in
//    let components = Calendar.current.dateComponents([.month], from: item.date)
//    return components.month!
//}
//
//print(dictionary)




let formatter = NumberFormatter()
formatter.numberStyle = .percent
formatter.minimumIntegerDigits = 1
formatter.maximumIntegerDigits = 1
formatter.maximumFractionDigits = 3

var values =  [1.623,1.614,1.591,1.577,1.600,1.579,1.622, 0.89]
values.reverse()
let percentages = [0] + zip(values, values.dropFirst()).map {
    (old, new) in
    return (100.0 * (new - old) / old)
}

print(percentages.compactMap { formatter.string(from: NSNumber(value: $0 / 100.0)) })

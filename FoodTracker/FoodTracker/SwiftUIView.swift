//
//  SwiftUIView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/10/23.
//

import SwiftUI

struct SwiftUIView: View {

    @State private var foodData = [FoodData]()
    @State private var dateValue = 1
    @State private var inputedInfo = ""

    var body: some View {
        HStack {
            TextField("Input", text: $inputedInfo)

            Button("Save") {
                dateAmount()
            }
        }

    }



    func dateAmount() {
        
        // Default value for the expiration
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

        let item1 = FoodData(id: "expired", food: inputedInfo, amount: "3", expirationDay: dateValue)
        let item2 = FoodData(id: "going bad soon", food: "foodItem.text", amount: "3", expirationDay: 5)
        let item3 = FoodData(id: "fresh", food: "foodItem.text", amount: "3", expirationDay: 0)

        var data: [FoodData] = [item1, item2, item3, FoodData(id: expiration, food: inputedInfo, amount: "2", expirationDay: 5)]
            let foodInfo = FoodData(id: expiration, food: "foodItem.text", amount: "3", expirationDay: dateValue)
        foodData.append(contentsOf: data)
        print("after append foodData")
        
        print(foodData)
        print()
        print()
        
        let dictionary = Dictionary(grouping: foodData, by: { $0.id })
        
        print("dictionary")
        print(dictionary)
        
        print()
        print()
        print("foodData two")
        
        print(foodData)
    }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView()
    }
}






















//
//struct SwiftUIView: View {
//
//
//
//    @Binding var foodData: [FoodData]
//    @State private var food = ""
//    @State private var expirationDay = 0
//
//    var body: some View {
//        Form {
//            Section {
//                TextField("Food Name", text: $food)
//            }
//
//            Section(header: Text("Expiration Day")) {
//                Picker("Expiration Day", selection: $expirationDay) {
//                    Text("Fresh").tag(0)
//                    Text("Going bad soon").tag(1)
//                    Text("Expired").tag(2)
//                }
//                .pickerStyle(SegmentedPickerStyle())
//            }
//
//            Section {
//                Button(action: {
//                    foodData.append(FoodData(food: food, expirationDay: expirationDay))
//                }) {
//                    Text("Add Food")
//                }
//            }
//        }
//        .navigationBarTitle(Text("Add Food"))
//    }
//}
//
//
//
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationLink(destination: SwiftUIView(foodData: $foodData)) {
//            Text("Add Food")
//        }
//    }
//}

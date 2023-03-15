//
//  SwiftUIView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/10/23.
//

import SwiftUI

struct SwiftUIView: View {

    @Binding var foodData: [FoodData]
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
        var expiration = 0

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        print(dateFormatter.string(from: date))

        var future = dateFormatter.date(from: "03/20/2023")
        let timeDiff = future?.timeIntervalSinceNow
        let daysDiff = Int(timeDiff! / (24 * 60 * 60) + 1)


        dateValue = daysDiff

        if dateValue == 0 {
            expiration = 0
        } else if dateValue <= 7 {
            expiration = 1
        } else {
            expiration = 2
        }

        let item1 = FoodData(id: 2, food: inputedInfo, amount: "3", expirationDay: dateValue)
        let item2 = FoodData(id: 3, food: "foodItem.text", amount: "3", expirationDay: 5)
        let item3 = FoodData(id: 4, food: "foodItem.text", amount: "3", expirationDay: 0)

        let data: [FoodData] = [item1, item2, item3]
            let foodInfo = FoodData(id: 5, food: inputedInfo, amount: "3", expirationDay: expiration)
        
        foodData.append(contentsOf: data)
        print()
        print(foodData)
        print()
        foodData.append(foodInfo)
        print()
        print(foodData)
        print()
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
        SwiftUIView(foodData: .constant([]))
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

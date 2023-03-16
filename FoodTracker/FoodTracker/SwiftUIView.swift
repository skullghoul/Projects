//
//  SwiftUIView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/10/23.
//

import SwiftUI

struct SwiftUIView: View {


    @State private var selectedDate = Date.now


    @Binding var foodData: [FoodData]
    @State private var dateValue = 1
    @State private var inputedInfo = ""


    var body: some View {
        VStack {
            HStack() {
                
                
                TextField("Input", text: $inputedInfo)
                
                Button("Save") {
                    dateAmount()
                }
                
                
            }
            DatePicker("Expiration Date", selection: $selectedDate, in: Date.now..., displayedComponents: .date)
                .pickerStyle(.inline)
        }
    }



    func dateAmount() {

        // Default value for the expiration
        var expiration = 0

        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        print(dateFormatter.string(from: date))

        var changedString = dateFormatter.string(from: selectedDate)
        var future = dateFormatter.date(from: changedString)
        let timeDiff = future?.timeIntervalSinceNow
        let daysDiff = Int(timeDiff! / (24 * 60 * 60) + 1)

        var id = foodData.count
        
        id += 1
        
        dateValue = daysDiff

        if dateValue == 0 {
            expiration = 2
        } else if dateValue <= 7 {
            expiration = 1
        } else if dateValue >= 8{
            expiration = 0
        } else {
            print("failed to find dateValue unexepected number \(dateValue)")
        }
//
//        let item1 = FoodData(id: 2, food: inputedInfo, amount: "3", expirationDay: dateValue)
//        let item2 = FoodData(id: 3, food: "foodItem.text", amount: "3", expirationDay: 5)
//        let item3 = FoodData(id: 4, food: "foodItem.text", amount: "3", expirationDay: 0)

//        let data: [FoodData] = [item1, item2, item3]
        let foodInfo = FoodData(id: id, amountofDaysTillExpiration: daysDiff, calendarDate: selectedDate, food: inputedInfo, amount: "3", expirationNameValue: expiration)
        
//        foodData.append(contentsOf: data)

        foodData.append(foodInfo)
print(foodData)
        
        let dictionary = Dictionary(grouping: foodData, by: { $0.id })
        

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

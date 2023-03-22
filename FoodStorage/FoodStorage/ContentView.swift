//
//  ContentView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    
    @FetchRequest(sortDescriptors: []) var foodData: FetchedResults<Item>
        
    @State private var checkEditIsPushed = false
    @State private var selectedFood: Item? = nil
    @State private var presentSheet = false

    @State private var showingEditAlert: Bool = false
    
    var groupedFoodData: [String: [Item]] {
        Dictionary(grouping: foodData) { food in
            switch food.expirationNameValue {
            case 0:
                return "Fresh"
            case 1:
                return "Going bad soon"
            default:
                return "Expired"
            }
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(["Expired", "Going bad soon", "Fresh"], id: \.self) { key in
                        Section(header: Text(key)) {
                            if let foods = groupedFoodData[key] {
                                ForEach(foods, id: \.uuid) { food in
                                    Button(action: {
                                        selectedFood = food
                                        presentSheet = true
                                        checkEditIsPushed = true
                                    }) {
                                        HStack {
                                            Text("\(food.amountofDaysTillExpiration) Days")
                                                .bold()
                                            Spacer()
                                            VStack(alignment: .leading) {
                                                Text(food.food ?? "")
                                                Text("\(food.amount ?? "0") left in stock")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            Spacer()
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    
                                }
                            }
                        }
                    }
                }
                
                .colorMultiply(.init("Color"))
                .scrollContentBackground(.hidden)
                .navigationBarTitle("Food Tracker")
                .navigationBarItems(trailing: Toggle(isOn: $presentSheet) {
                    Image("PlusOneButton")
                        .resizable()
                        .frame(width: 70, height: 70)
                })
                                    
                    .sheet(isPresented: $presentSheet, content: {
                        SwiftUIView(checkEditIsPushed: $checkEditIsPushed, presentSheet: $presentSheet, selectedFood: $selectedFood)
                    })
            
            .background {
                Image("orangeRed")
                    .resizable()
                    .frame(width: 500, height: 1100)
            }
            .navigationTitle("Hello")
        }
    }
    
        }
        
        
}

    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /// Old Data
    ///
    /// //
    //  ContentView.swift
    //  FoodTracker
    //
    //  Created by Zander Ewell on 3/5/23.
    //
    
//    import SwiftUI
//
//    struct ContentView: View {
//
//
//        @State private var selectedFood: FoodData? = nil
//
//
//
//
//        @State var presentSheet = false
//        //    @State var foodData: [FoodData]
//
//        @State private var foodData = [FoodData]()
//
//
//        var groupedFoodData: [String: [FoodData]] {
//            Dictionary(grouping: foodData) { food in
//                switch food.expirationNameValue {
//                case 0:
//                    print("fresh \(foodData)")
//                    return "Fresh"
//                case 1:
//                    print("Going bad soon \(foodData)")
//                    return "Going bad soon"
//
//                default:
//                    print("Expired \(foodData)")
//                    return "Expired"
//                }
//            }
//        }
//
//
//        var body: some View {
//
//            NavigationView {
//                ZStack {
//                    // - Creates a custom scrollable container
//
//                    List {
//
//                        // For each which grabs the dictionary data and loops through each of them and sorts them.
//                        ForEach(["Expired", "Going bad soon", "Fresh"], id: \.self) { key in
//                            Section(header: Text(key)) {
//                                if let foods = groupedFoodData[key] {
//                                    ForEach(foods, id: \.id) { food in
//                                        // - This line of code creates a vertical stack view (VStack) that arranges two text views vertically. The first text view displays the name of the food, which is stored in the food property of the current item. The second text view displays the amount of the food that is left, which is stored in the amount property of the current item. The second text view is styled using a smaller font size and a gray color.
//                                        Button(action: {
//                                            selectedFood = food
//                                        }) {
//                                            HStack {
//                                                Text("\(food.amountofDaysTillExpiration) Days")
//                                                    .bold()
//                                                Spacer()
//                                                VStack(alignment: .leading) {
//                                                    Text(food.food)
//
//                                                    Text("\(food.amount) left in stock")
//                                                        .font(.caption)
//                                                        .foregroundColor(.gray)
//                                                }
//                                                Spacer()
//                                            }
//                                        }
//                                        .buttonStyle(PlainButtonStyle())
//
//                                        .alert(item: $selectedFood) { food in
//                                            // Use a Binding to update the food data
//                                            var editedFood = food
//                                            return Alert(title: Text("Edit \(food.food)"), message: nil, primaryButton: .default(Text("Save")) {
//                                                if let index = foodData.firstIndex(where: { $0.id == food.id }) {
//                                                    editedFood.food = food.food // Update food name
//                                                    editedFood.amount = food.amount // Update amount
//                                                    editedFood.amountofDaysTillExpiration = food.amountofDaysTillExpiration // Update amount of days
//                                                    foodData[index] = editedFood // Update the original food data
//
//                                                    // Recalculate the grouped food data dictionary
//                                                    let newGroupedFoodData = Dictionary(grouping: foodData) { food in
//                                                        switch food.expirationNameValue {
//                                                        case 0:
//                                                            print("fresh \(foodData)")
//                                                            return "Fresh"
//                                                        case 1:
//                                                            print("Going bad soon \(foodData)")
//                                                            return "Going bad soon"
//                                                        default:
//                                                            print("Expired \(foodData)")
//                                                            return "Expired"
//                                                        }
//                                                    }
//
//                                                    // Update the state variable with the new grouped food data
//                                                    self.foodData = foodData
//                                                }
//                                            }, secondaryButton: .cancel())
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                    .colorMultiply(.init("Color"))
//                    .scrollContentBackground(.hidden)
//
//
//                    // Button for when to tell the sheeet to present
//                    .navigationBarTitle("Food Tracker")
//                    .navigationBarItems(trailing:
//                                            Toggle(isOn: $presentSheet) {
//                        Image("PlusOneButton", label: Text("Zander"))
//                            .resizable()
//                            .frame(width: 80, height: 80)
//
//                    }
//
//                    )
//                    // present sheet and makes the swiftui data appear
//                    .sheet(isPresented: $presentSheet) {
//                        SwiftUIView(foodData: $foodData)
//                    }
//                }
//                .background {
//                    Image("orangeRed")
//                        .resizable()
//                        .frame(width: 500, height: 1100)
//                }
//
//                .navigationTitle("Hello")
//
//            }
//
//        }
//    }
//
//
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
//
//
//

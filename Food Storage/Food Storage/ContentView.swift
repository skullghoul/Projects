//
//  ContentView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import SwiftUI

struct ContentView: View {
    
    
    
    
    
    
    @State var presentSheet = false
    //    @State var foodData: [FoodData]
    
    @State private var foodData = [FoodData]()
    
    
    var groupedFoodData: [String: [FoodData]] {
        Dictionary(grouping: foodData) { food in
            switch food.expirationNameValue {
            case 0:
                print("fresh \(foodData)")
                return "Fresh"
            case 1:
                print("Going bad soon \(foodData)")
                return "Going bad soon"
                
            default:
                print("Expired \(foodData)")
                return "Expired"
            }
        }
    }
    
    
    var body: some View {
        
        NavigationView {
            ZStack {
                // - Creates a custom scrollable container
                
                List {
                    
                    // For each which grabs the dictionary data and loops through each of them and sorts them.
                    ForEach(["Expired", "Going bad soon", "Fresh"], id: \.self) { key in
                        Section(header: Text(key)) {
                            if let foods = groupedFoodData[key] {
                                ForEach(foods, id: \.id) { food in
                                    // - This line of code creates a vertical stack view (VStack) that arranges two text views vertically. The first text view displays the name of the food, which is stored in the food property of the current item. The second text view displays the amount of the food that is left, which is stored in the amount property of the current item. The second text view is styled using a smaller font size and a gray color.
                                    HStack {
                                        Text("\(food.amountofDaysTillExpiration) Days")
                                            .bold()
                                        Spacer()
                                        VStack(alignment: .leading) {
                                            Text(food.food)
                                            
                                            Text("\(food.amount) left in stock")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                }
                
                .colorMultiply(.init("Color"))
                .scrollContentBackground(.hidden)
                
                
                // Button for when to tell the sheeet to present
                .navigationBarTitle("Food Tracker")
                .navigationBarItems(trailing:
                                        Toggle(isOn: $presentSheet) {
                    Image("PlusOneButton", label: Text("Zander"))
                        .resizable()
                        .frame(width: 80, height: 80)
                    
                }
                                    
                )
                // present sheet and makes the swiftui data appear
                .sheet(isPresented: $presentSheet) {
                    SwiftUIView(foodData: $foodData)
                }
            }
            .background {
                Image("orangeRed")
                    .resizable()
                    .frame(width: 500, height: 1100)
            }
            
            .navigationTitle("Hello")
            
        }
        
    }
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}



//
//  ContentView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
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
                                            let dateFormatter = DateFormatter()
                                            Text(food.calendarDate ?? "")
                                                .fixedSize()
                                            
                                            
                                            
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 3)
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
                    Color.black.opacity(0.08)
                        .frame(width: 500, height: 1100)
                }

                
                
                
            }
        }
    }
    
//    func updateData() {
//        let today = Date()
//        let request = NSFetchRequest<Item>(entityName: "Item")
//        request.predicate = NSPredicate(format: "expirationDate <= %@", today as NSDate)
//        do {
//            let expiredItems = try moc.fetch(request)
//            for item in expiredItems {
//                switch item.expirationNameValue {
//                case 0:
//                    item.expirationNameValue = 2
//                case 1:
//                    item.expirationNameValue = 0
//                default:
//                    break
//                }
//                let calendar = Calendar.current
//                let newDate = calendar.date(byAdding: .day, value: Int(item.amountofDaysTillExpiration), to: today)
//                item.calendarDate = newDate
//            }
//            try moc.save()
//        } catch {
//            print("Error updating data: \(error)")
//        }
//    }
    
    
    
    
    }


    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
    
    
    
 

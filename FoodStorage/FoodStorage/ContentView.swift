//
//  ContentView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import CoreData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(sortDescriptors: []) var foodData: FetchedResults<Item>
    
    @State private var checkEditIsPushed = false
    @State private var selectedFood: Item? = nil
    @State private var presentSheet = false
    @State private var headingTitles = ["Expired", "Going bad soon", "Fresh"]
    
    @State private var grabGroupedKeyData: [Item] = []
    
    @State private var showingEditAlert: Bool = false
    
    @State private var alertForListAmount = false
    
    @State private var alertAmountInput = ""

    
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
                    ForEach(headingTitles, id: \.self) { key in
                        
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
                                            
                                            .swipeActions(edge: .leading) {
                                                Button("Add to list") {
                                                    alertForListAmount = true
                                                    
                                                    
                                                }
                                            }
                                                .alert("Input amount", isPresented: $alertForListAmount) {
                                                    TextField("Zander", text: $alertAmountInput)
                                                    Button("OK", role: .cancel) {
                                                        let listing = ListGroceries(context: moc)
                                                        listing.uuid  = UUID()
                                                        listing.name = food.food
                                                        listing.amount = alertAmountInput
                                                        
                                                        try? moc.save()
                                                        
                                                        alertAmountInput = ""
                                                    }
                                                }
                                                                                    
                                            .tint(.black)
                                            Spacer()
                                            let dateFormatter = DateFormatter()
                                            Text(food.calendarDate ?? "")
                                                .fixedSize()
                                            
                                            
                                            
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 3)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onChange(of: scenePhase) { newPhase in
                                        switch newPhase {
                                            case .inactive:
                                            print("inactive")
                                            updatingData()
                                        case .active:
                                            print("active")
                                            updatingData()
                                        case .background:
                                            print("background")
                                        }
                                    }
                                    .onAppear{
                                        print("Food Name: \(food.food), id: \(food.uuid), Key \(key)")
                                    }
                                    
                                }
                                
                                .onDelete{ indexSet in
                                    delete(at: indexSet, key: key)
                                }
                            }
                                
                        }
                        
                    }
                    
                }
//                .onAppear {
//                    updatingData()
//                    print("Made it to on appear")
//                }
//
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
    
    func updatingData() {
        let today = Date()
        let request = NSFetchRequest<Item>(entityName: "Item")
        request.predicate = NSPredicate(format: "calendarDate <= %@", today as NSDate)
        do {
            let expiredItems = try moc.fetch(request)
            for item in expiredItems {
                let calendar = Calendar.current
                let newDate = calendar.date(byAdding: .day, value: Int(item.amountofDaysTillExpiration), to: today)
                let daysUntilExpiration = calendar.dateComponents([.day], from: today, to: newDate!).day ?? 0
                switch daysUntilExpiration {
                case ...0:
                    item.expirationNameValue = 2 // "Expired"
                case 1...3:
                    item.expirationNameValue = 1 // "Going bad soon"
                default:
                    item.expirationNameValue = 0 // "Fresh"
                }
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none
                item.calendarDate = dateFormatter.string(from: newDate!)
                let daysFromToday = calendar.dateComponents([.day], from: today, to: newDate!).day ?? 0
                item.amountofDaysTillExpiration = Int16(daysFromToday)
            }
            try moc.save()
        } catch {
            print("Error updating data: \(error)")
        }
    }
    

    
    func delete(at offsets: IndexSet, key: String) {
//        let foodItem: Item
//        switch key {
//        case "Expired":
//
//        case "Going bad soon":
//        case "Fresh":
//        default: return
//        }
        
        
        
        for index in offsets {
            guard let item = groupedFoodData[key]?[index] else { return }
            moc.delete(item)
        }
        do {
            try moc.save()
        } catch {
            print("Error updating data: \(error)")
        }

        
    }
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}





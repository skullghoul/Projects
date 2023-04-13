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
    
    @Environment(\.colorScheme) var colorScheme
    
    
    @FetchRequest(sortDescriptors: []) var foodData: FetchedResults<Item>
    
    @State private var checkEditIsPushed = false
    @State private var selectedFood: Item? = nil
    @State private var presentSheet = false
    @State private var headingTitles = ["Expired", "Going bad soon", "Fresh"]
    
    @State private var grabGroupedKeyData: [Item] = []
    
    @State private var showingEditAlert: Bool = false
    
    @State private var alertForListAmount = false
    
    @State private var alertAmountInput = ""
    
    @State private var foodForAddingToList = ""
    
    
    
    
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
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
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
                                            Text("\(food.daysApartFromNowToSelectedDate) Days")
                                                .bold()
                                            Spacer()
                                            VStack(alignment: .center) {
                                                Text(food.nameOfFood ?? "").font(.system(size: 20)).foregroundColor(colorScheme == .dark ? Color("ForegroundColorForName") : .pink)
                                                Text("\(food.amount ?? "0") left in stock")
                                                    .font(.caption)
                                                    .foregroundColor(.gray)
                                            }
                                            .swipeActions(edge: .leading) {
                                                Button("Add to list") {
                                                    alertForListAmount = true
                                                    foodForAddingToList = food.nameOfFood ?? ""
                                                }
                                            }
                                            .tint(.black)
                                            Spacer()
                                            
                                            Text(dateFormatter.string(from: food.calendarDate ?? Date.now))
                                                .fixedSize()
                                        }
                                        .foregroundColor(Color("GreenishBlue"))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 3)
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
                                        updatingData()
                                    }
                                    
                                    .onAppear{
                                        updatingData()
                                    }
                                    
                                }
                                
                                .onDelete{ indexSet in
                                    delete(at: indexSet, key: key)
                                }
                            }
                            
                        }
                        
                    }
                    .listRowBackground(Color("BackgroundOfContentViewList"))
                    .tint(Color("Teal"))
                }
                
                .alert("Input amount", isPresented: $alertForListAmount) {
                    
                    TextField("Amount of items", text: $alertAmountInput)
                    Button("Cancel", role: .cancel, action: {})
                    Button("OK") {
                        let listing = ListGroceries(context: moc)
                        listing.uuid  = UUID()
                        listing.name = foodForAddingToList
                        listing.amount = alertAmountInput
                        
                        try? moc.save()
                        
                        alertAmountInput = ""
                        foodForAddingToList = ""
                    }
                }
                
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
                    Color.black.opacity(0.10)
                        .frame(width: 500, height: 1100)
                }
            }
        }
    }
    
    func updatingData() {
        let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
        
        let today = Date.now
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "calendarDate >= %@", today as NSDate)
        do {
            let items = try moc.fetch(fetchRequest)
            for item in items {
                let date = Date()
                let calendar = Calendar.current
                let startOfDaySelectedDate = calendar.startOfDay(for: item.calendarDate ?? Date())
                let startOfDayToday = calendar.startOfDay(for: date)
                let components = calendar.dateComponents([.day], from: startOfDayToday, to: startOfDaySelectedDate)
                let daysDiff = components.day ?? 0
                print("DaysDiff = \(daysDiff)")
                
                item.daysApartFromNowToSelectedDate = Int16(daysDiff)
                
                switch item.daysApartFromNowToSelectedDate {
                case ...0:
                    item.expirationNameValue = 2 // "Expired"
                case 1...7:
                    item.expirationNameValue = 1 // "Going bad soon"
                default:
                    item.expirationNameValue = 0 // "Fresh"
                }
            }
            try moc.save()
        } catch {
            print("Error updating data: \(error)")
        }
    }
    
    
    func delete(at offsets: IndexSet, key: String) {
        
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

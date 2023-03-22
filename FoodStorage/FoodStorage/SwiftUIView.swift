//
//  SwiftUIView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/10/23.
//

import CoreData
import SwiftUI


struct SwiftUIView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.managedObjectContext) var context: NSManagedObjectContext
    
//    @Binding var foodData: [FoodData]
    @Binding var presentSheet: Bool
    @Binding var selectedFood: Item?
    @State private var selectedDate = Date()
    @State private var inputedInfo = ""
    @State private var amountValue = 1
    @State private var closeDate = false
    @State private var angle = 0.0

    @State private var discardDateString = ""
    
    @State private var width: Bool = true
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    presentSheet = false
                    selectedFood = nil
                }
                Spacer()
                .interactiveDismissDisabled()

                
                Button("Save") {
                    dateAmount()
                }
            }
            .padding(7)
            
            TextField("Input Name of Item (ex. Carrots)", text: $inputedInfo)
                .padding(7)
            HStack {
                
                Spacer()
                Section(header: Text("Item Quantity:")) {
                    Spacer()
                    Picker("Item Amount", selection: $amountValue) {
                        ForEach(0 ..< 600) {
                            Text(String(format: "%01d", $0))
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                    .frame(width: 120)
                }
                Spacer()
            }
            HStack {
                Spacer()
                VStack{
                    Text(width ? "Tap to close" : "")
                        .font(.system(size: 10))
                        .padding(.horizontal, 10)

                    Button {
                        if width == true {
                            width.toggle()
                        } else {
                            width.toggle()
                        }
                        
                        if closeDate == true {
                            closeDate.toggle()
                            angle += 360
                        } else {
                            closeDate.toggle()
                            angle -= 360
                        }
                    } label: {
                        if closeDate == true {
                            Image(systemName: "calendar.circle.fill").resizable().frame(width:35, height: 35)
                        } else {
                            Image(systemName: "calendar.circle").resizable().frame(width:35, height: 35)
                        }
                    }
                    .rotationEffect(.degrees(angle))
                    .animation(.linear(duration: 0.8), value: angle)
                    .font(.system(size: 10))
                    .padding(.horizontal, 10)
                }
                }
                DatePicker("Expiration Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(width: width ? .maximum(500, 30) : 0)
            
            TextField("Discard Product Date", text: $discardDateString)
                .frame(width: width ? 0 : .maximum(500, 30))
            }
        .transition(.slide)
        .transition(.scale)
        .animation(.easeInOut, value: width)

        .onAppear {
            if let food = selectedFood {
                inputedInfo = food.food ?? ""
                amountValue = Int(food.amount ?? "") ?? 1
                selectedDate = food.calendarDate ?? Date.now
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

        let changedString = dateFormatter.string(from: selectedDate)
        let future = dateFormatter.date(from: changedString)
        let timeDiff = future?.timeIntervalSinceNow
        let daysDiff = Int(timeDiff! / (24 * 60 * 60) + 1)

        var createNewUuid = UUID()
        
        let uuid = selectedFood?.uuid ?? createNewUuid


        var dateValue = 0
        
        dateValue = daysDiff

        if dateValue == 0 {
            expiration = 2
        } else if dateValue <= 7 {
            expiration = 1
        } else if dateValue >= 8 {
            expiration = 0
        } else {
            print("failed to find dateValue unexpected number \(dateValue)")
        }

        
//        let foodInfo = FoodData(
//            id: Int(id),
//            amountofDaysTillExpiration: daysDiff,
//            calendarDate: selectedDate,
//            food: inputedInfo,
//            amount: String(amountValue),
//            expirationNameValue: expiration
//        )

        let item = Item(context: context)
        item.amountofDaysTillExpiration = Int16(daysDiff)
        item.calendarDate = selectedDate
        item.food = inputedInfo
        item.amount = String(amountValue)
        item.expirationNameValue = Int16(expiration)
        item.uuid = uuid
        try? moc.save()
        

        
        
    // MARK: you need to make this work for CoreData
        

//        if let index = foodData.firstIndex(where: { $0.id == id }) {
////            foodData[index] = foodInfo
//            foodData.remove(at: index)
//            foodData.append(foodInfo)
//
//        } else {
//            foodData.append(foodInfo)
//        }

        presentSheet = false
        selectedFood = nil

    }
    


}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(presentSheet: .constant(true), selectedFood: .constant(Item()))
    }
}

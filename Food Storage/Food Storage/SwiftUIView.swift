//
//  SwiftUIView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/10/23.
//

import SwiftUI

struct SwiftUIView: View {
    //    @Environment(\.managedObjectContext) var moc
    //    @FetchRequest(sortDescriptors: []) var students: FetchedResults<Student>
    
    @State private var selectedDate = Date.now
    
    
    @Binding var foodData: [FoodData]
    @State private var dateValue = 1
    @State private var inputedInfo = ""
    @State private var amountValue = 1
    
    var body: some View {
        VStack {
            HStack() {
                
                
                TextField("Input", text: $inputedInfo)
                
                Button("Save") {
                    dateAmount()
                }
                
                
            }
            HStack{
                Picker("Item Amount", selection: $amountValue) {
                    ForEach(0 ..< 600) {
                        Text(String(format: "%02d", $0))
                    }
                    
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
        
        let changedString = dateFormatter.string(from: selectedDate)
        let future = dateFormatter.date(from: changedString)
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
        
        
        
        let foodInfo = FoodData(id: id, amountofDaysTillExpiration: daysDiff, calendarDate: selectedDate, food: inputedInfo, amount: String(amountValue), expirationNameValue: expiration)
        
        
        foodData.append(foodInfo)
        print(foodData)
    }
    
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(foodData: .constant([]))
    }
}


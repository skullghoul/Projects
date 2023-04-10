//  SwiftUIView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/10/23.
//

import Combine
import CoreData
import SwiftUI


extension View {
  var keyboardPublisher: AnyPublisher<Bool, Never> {
    Publishers
      .Merge(
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillShowNotification)
          .map { _ in true },
        NotificationCenter
          .default
          .publisher(for: UIResponder.keyboardWillHideNotification)
          .map { _ in false })
      .debounce(for: .seconds(0.1), scheduler: RunLoop.main)
      .eraseToAnyPublisher()
  }
}

struct SwiftUIView: View {

    @Environment(\.managedObjectContext) var moc

    @Environment(\.managedObjectContext) var context: NSManagedObjectContext

    @Binding var checkEditIsPushed: Bool
    @Binding var presentSheet: Bool
    @Binding var selectedFood: Item?
    @State private var selectedDate = Date()
    @State private var inputedInfo = ""
    @State private var amountValue = 1
    @State private var closeDate = false
    @State private var isKeyboardPresented = false
    @State private var angle = 0.0

    @State private var discardDateString = ""

    @State private var width: Bool = true

    var body: some View {
        VStack {
            VStack(spacing: 20) {
                HStack(alignment: .firstTextBaseline) {
                    Button("Cancel") {
                        presentSheet = false
                        selectedFood = nil
                        checkEditIsPushed = false
                    }
                    .frame(width: 60)
                    .position(x: 23, y: 23)
                    .interactiveDismissDisabled()
                }
                Spacer()
                TextField("Input Name of Item (ex. Carrots)", text: $inputedInfo)
            }

            .onReceive(keyboardPublisher) { value in
                print()
                print("Is keyboard visible? ", value)
                print()
                isKeyboardPresented = value
            }

            .frame(width: .maximum(360, 10), alignment: .leading)

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
                    .frame(width: 160, height: 250)
                }
                Spacer()
            }
//            HStack {
//                Spacer()
//                VStack{
//                    Text(width ? "Tap to close" : "")
//                        .font(.system(size: 10))
//                        .padding(.leading, 20)
//
//                    Button {
//                        if width == true {
//                            width = false
//                        } else {
//                            width = true
//                        }
//
//                        if closeDate == true {
//                            closeDate.toggle()
//                            angle += 360
//                        } else {
//                            closeDate.toggle()
//                            angle -= 360
//                        }
//                    } label: {
//                        if closeDate == true {
//                            Image(systemName: "calendar.circle.fill").resizable().frame(width:35, height: 35)
//                        } else {
//                            Image(systemName: "calendar.circle").resizable().frame(width:35, height: 35)
//                        }
//                    }
//                    .rotationEffect(.degrees(angle))
//                    .animation(.linear(duration: 0.8), value: angle)
//                    .font(.system(size: 10))
//                    .padding(.leading, 60)
//                }
//                .padding(.horizontal, 60)
//
//            }
            VStack {
                DatePicker("Expiration Date", selection: $selectedDate, in: Date()..., displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .frame(width: isKeyboardPresented ? 0 : 340, height: isKeyboardPresented ? 0 : 320)
                    .background {
                        Color("SkyBlueSWUIView")

                    }

                //                TextField("Discard Product Date", text: $discardDateString)
                //
                //                    .frame(width: width ? 0 : .maximum(500, 30))
            }
            .transition(.slide)
            .transition(.scale)
            .animation(.easeInOut, value: width)

            .onAppear {
                if let food = selectedFood {
                    inputedInfo = food.nameOfFood ?? ""
                    amountValue = Int(food.amount ?? "") ?? 1

                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM/dd/yy"
                    selectedDate = food.calendarDate ?? Date()
                }
            }
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
        let selectedDaySaved = dateFormatter.string(from: selectedDate)

        let calendar = Calendar.current
        let startOfDaySelectedDate = calendar.startOfDay(for: selectedDate)
        let startOfDayToday = calendar.startOfDay(for: date)
        let components = calendar.dateComponents([.day], from: startOfDayToday, to: startOfDaySelectedDate)
        let daysDiff = components.day ?? 0

        let createNewUuid = UUID()
        let uuid = selectedFood?.uuid ?? createNewUuid

        var dateValue = 0
        dateValue = daysDiff

        if dateValue <= 0 {
            expiration = 2
        } else if dateValue <= 7 {
            expiration = 1
        } else if dateValue >= 8 {
            expiration = 0
        } else {
            print("failed to find dateValue unexpected number \(dateValue)")
        }

        if checkEditIsPushed == false {
            let item = Item(context: context)
            item.daysApartFromNowToSelectedDate = Int16(daysDiff)
            item.calendarDate = selectedDate // Updated line
            item.nameOfFood = inputedInfo
            item.amount = String(amountValue)
            item.expirationNameValue = Int16(expiration)
            item.uuid = uuid
            try? moc.save()
        } else if checkEditIsPushed == true {

            let convertUUIDString = uuid.uuidString
            guard let uuid = UUID(uuidString: convertUUIDString) else {
                return
            }

            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)

            do {
                let result = try moc.fetch(fetchRequest)
                guard let objectToUpdate = result.first else {
                    return
                }
                objectToUpdate.daysApartFromNowToSelectedDate = Int16(daysDiff)
                objectToUpdate.calendarDate = selectedDate // Updated line
                objectToUpdate.nameOfFood = inputedInfo
                objectToUpdate.amount = String(amountValue)
                objectToUpdate.expirationNameValue = Int16(expiration)
                try? moc.save()
            } catch {
                print("Error fetching object: \(error.localizedDescription)")
            }

        } else {
            print("failed to find checkEditIsPushed")
        }

        presentSheet = false
        selectedFood = nil
        checkEditIsPushed = false

    }


}



struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        SwiftUIView(checkEditIsPushed: .constant(false), presentSheet: .constant(true), selectedFood: .constant(Item()))
    }
}

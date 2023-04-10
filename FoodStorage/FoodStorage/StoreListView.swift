//
//  StoreList.swift
//  FoodStorage
//
//  Created by Zander Ewell on 3/23/23.
//

import CoreData
import SwiftUI

struct StoreListView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @Environment(\.colorScheme) var colorScheme
    
    @FetchRequest(sortDescriptors: []) var lists: FetchedResults<ListGroceries>
    
    @State private var showAlert = false
    @State private var inputedText = ""
    @State private var inputedAmount = ""
    @State private var checkEditing = false
    
    @State private var checkMark: Bool = false
    
    @State private var listEdit: ListGroceries? = nil
    
    @State private var checkMarkData: ListGroceries? = nil
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    
                    ForEach(lists, id: \.uuid) { list in
                        HStack {
                            
                            
                            Button(action: {
                                
                            }) {
                                
                                HStack() {
                                    Text(list.name ?? "")
                                        .multilineTextAlignment(.leading)
                                        .frame(width: 100)
                                    
                                    
                                    
                                    Text("Quantity:   \(list.amount ?? "")")
                                        .multilineTextAlignment(.center)
                                        .frame(width: 100)
                                    
                                    
                                }
                            }
                            .onTapGesture {
                                print("quantity pressed")
                                checkEditing = true
                                listEdit = list
                                inputedText = list.name ?? ""
                                inputedAmount = list.amount ?? ""
                                showAlert = true
                            }
                            
                            
                            
                            Button {
                            } label: {
                                Image(systemName: list.isChecked ? "checkmark" : "square")
                                    .foregroundColor(list.isChecked ? .green : .black)
                            }
                            .frame(width: 100)
                            .onTapGesture {
                                list.isChecked.toggle()
                                checkMark = list.isChecked
                                print("Checkmark Button pressed")
                            }
                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                checkMarkData = list
                                list.isChecked.toggle()
                                checkMark = list.isChecked
                                updateCheckIcon()
                                print("Swipe Action")
                            } label: {
                                Label(
                                    title: {
                                        Text(list.isChecked ? "checked" : "not checked")
                                    },
                                    icon: {
                                        ZStack {
                                            Circle()
                                                .stroke(Color.black, lineWidth: 2)
                                            
                                            Image(systemName: list.isChecked ? "checkmark" : "square")
                                            
                                        }
                                        .frame(width: 25, height: 25)
                                    }
                                )
                            }
                            
                        }
                        .tint(list.isChecked ? .green : .black)
                        
                        
                        
                        .onAppear {
                            updateCheckIcon()
                        }
                        
                    }


                    
                    .onDelete(perform: removeListData)
                    .listRowBackground(LinearGradient(gradient: Gradient(colors: [.blue, .white, .pink]), startPoint: .leading, endPoint: .trailing))
                }


                .navigationBarTitle("Grocery List")


                Button("Tap me") {
                    showAlert = true
                    
                }
                
            }

            .alert("Zander", isPresented: $showAlert) {
                TextField("Input name", text: $inputedText)
                TextField("Input Amount", text: $inputedAmount).keyboardType(.numberPad)
                Button("Save", action: {inputedData()})
                Button("Cancel", role: .cancel, action: {
                    checkEditing = false
                    showAlert = false
                    inputedText = ""
                    inputedAmount = ""
                })
            }

            
        }

    }
    
    func updateCheckIcon() {
        guard let uuid =  checkMarkData?.uuid else { return }
        
        let convertUUIDString = uuid.uuidString
        guard let uuid = UUID(uuidString: convertUUIDString) else {
            return
        }
        
        let fetchRequest: NSFetchRequest<ListGroceries> = ListGroceries.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
        
        do {
            let result = try moc.fetch(fetchRequest)
            guard let objectToUpdate = result.first else {
                return
            }
            
            objectToUpdate.isChecked = checkMark
            try? moc.save()
            
        } catch {
            print("Error fetching object: \(error.localizedDescription)")
        }
    }
    
    
    func inputedData() {
        if checkEditing == false {
            let listing = ListGroceries(context: moc)
            listing.uuid  = UUID()
            listing.amount = inputedAmount
            listing.name = inputedText
            
            try? moc.save()
            
            inputedText = ""
            inputedAmount = ""
            
        } else if checkEditing == true {
            let uuid = listEdit?.uuid
            
            let convertUUIDString = uuid!.uuidString
            guard let uuid = UUID(uuidString: convertUUIDString) else {
                return
            }
            
            let fetchRequest: NSFetchRequest<ListGroceries> = ListGroceries.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "uuid == %@", uuid as CVarArg)
            
            do {
                let result = try moc.fetch(fetchRequest)
                guard let objectToUpdate = result.first else {
                    return
                }
                
                objectToUpdate.amount = inputedAmount
                objectToUpdate.name = inputedText
                
                
                try? moc.save()
                
                checkEditing = false
                listEdit = nil
            } catch {
                print("Error fetching object: \(error.localizedDescription)")
            }
            
        } else {
            print("failed to find checkEditIsPushed")
        }
        
        inputedText = ""
        inputedAmount = ""
    }
    
    
    
    func removeListData(at offsets: IndexSet) {
        for index in offsets {
            let list = lists[index]
            moc.delete(list)
        }
        do {
            try moc.save()
        } catch {
            // handle the Core Data error
        }
    }
}

struct StoreList_Previews: PreviewProvider {
    static var previews: some View {
        StoreListView()
    }
}

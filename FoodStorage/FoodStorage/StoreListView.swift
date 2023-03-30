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
                        Button(action: {
                            checkEditing = true
                            listEdit = list
                            inputedText = list.name ?? ""
                            showAlert = true
                        }) {
                            
                            HStack {
                                Text(list.name ?? "")
                                Text("\(list.amount ?? "")")
                            }

                        }
                        .swipeActions(edge: .leading, allowsFullSwipe: false) {
                            Button {
                                checkMarkData = list
                                list.isChecked.toggle()
                                checkMark = list.isChecked
                                print("checkmark is \(checkMark) ")
                                updateCheckIcon()

                                
                                print("\(list.name) is \(list.isChecked)")
                                print("Edit button was tapped")
                            } label: {
                                if list.isChecked == true {
                                    Label("checked", systemImage: "checkmark.square")
                                } else if list.isChecked == false {
                                    Label("not checked", systemImage: "square")
                                }
                            }
                        }
                    
                        .onAppear {
                            updateCheckIcon()
                        }

                    }


                    .onDelete(perform: removeListData)
                    
                }

                Button("Tap me") {
                    showAlert = true
                    
                }
                .alert("Zander", isPresented: $showAlert) {
                    TextField("Input Amount", text: $inputedAmount).keyboardType(.numberPad)
                    TextField("Input name", text: $inputedText)
                    Button("Save", action: {inputedData()})
                    Button("Cancel", role: .cancel, action: {
                        inputedText = ""
                        inputedAmount = ""
                    })
                }
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
            print(objectToUpdate.isChecked)
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

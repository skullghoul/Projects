//
//  FoodStorageApp.swift
//  FoodStorage
//
//  Created by Zander Ewell on 3/21/23.
//


import SwiftUI

@main
struct FoodStorageApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            TableUIView()

                .environment(\.managedObjectContext, persistenceController.viewContext)

        }
    }
}

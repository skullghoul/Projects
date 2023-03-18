//
//  BookwormApp.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/16/23.
//

import SwiftUI

struct BookwormApp: App {
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}



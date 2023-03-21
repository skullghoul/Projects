//
//  TestingCoreDataApp.swift
//  TestingCoreData
//
//  Created by Zander Ewell on 3/20/23.
//

import SwiftUI

@main
struct TestingCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

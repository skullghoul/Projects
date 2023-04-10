//
//  ListView.swift
//  FoodStorage
//
//  Created by Zander Ewell on 3/23/23.
//

import SwiftUI

struct TableUIView: View {
    var body: some View {
        TabView {
            ContentView()
                .tabItem {
                    Label("Food Tracker", systemImage: "list.dash")
                }
            
            StoreListView()
                .tabItem {
                    Label("Grocery List", systemImage: "checklist")
                }
        }.tint(Color("BurntOrange"))
            .foregroundColor(Color("ForegroundForTableView"))
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        TableUIView()
    }
}

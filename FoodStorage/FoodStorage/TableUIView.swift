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
                    Label("Menu", systemImage: "list.dash")
                }
            
            StoreListView()
                .tabItem {
                    Label("Order", systemImage: "checklist")
                }
        }.tint(.black)
        
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        TableUIView()
    }
}

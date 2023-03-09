//
//  ContentView.swift
//  FoodTracker
//
//  Created by Zander Ewell on 3/5/23.
//

import SwiftUI


var food = [FoodData]()
var dateValue = 1


struct ContentView: View {
    var body: some View {
        List {
            ForEach(items, id: \.0) { sectionTitle, sectionItems in
                Section(header: Text(sectionTitle)) {
                    ForEach(sectionItems, id: \.self) { item in
                        Text(item)
                    }
                }
            }
        }
    }
}





struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  LastEventsListView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 23/05/22.
//

import SwiftUI

struct LastEventsListView: View {
    
    @ObservedObject var categoryVM = CategoryViewModel()
    @State private var pickerTabs = ["Overview", "Cost", "Fuel", "Odometer"]
    var body: some View {
        NavigationView {
            VStack {
//                CustomSegmentedPicker()
                Spacer()
            }
            .navigationTitle("Last Events")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
    

}

struct LastEventsListView_Previews: PreviewProvider {
    static var previews: some View {
        LastEventsListView()
    }
}

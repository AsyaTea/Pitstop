//
//  LastEventsView.swift
//  Hurricane
//
//  Created by Asya Tealdi on 06/05/22.
//

import SwiftUI

struct LastEventsView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            
            VStack(spacing: 15) {
                
                ForEach(0..<10) { _ in
                    Text("Espenses")
                }
            }
        })
    }
}

struct LastEventsView_Previews: PreviewProvider {
    static var previews: some View {
        LastEventsView()
    }
}

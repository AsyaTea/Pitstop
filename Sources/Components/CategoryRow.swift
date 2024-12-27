//
//  CategoryRow.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 19/05/23.
//

import SwiftUI

struct CategoryRow: View {
    var title: String
    var icon: ImageResource
    var color: Color

    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 32, height: 32)
                    .foregroundColor(color)
                Image(icon)
                    .resizable()
                    .frame(width: 16, height: 16)
            }
            Text(title)
                .font(Typography.headerM)
        }
    }
}

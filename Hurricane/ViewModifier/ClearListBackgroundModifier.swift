//
//  ClearListBackgroundModifier.swift
//  Hurricane
//
//  Created by Ivan Voloshchuk on 18/05/23.
//

import SwiftUI

struct ClearListBackgroundModifier: ViewModifier {
    init() {
        if #unavailable(iOS 16.0) {
            UITableView.appearance().backgroundColor = .clear
        }
    }

    func body(content: Content) -> some View {
        if #available(iOS 16.0, *) {
            content
                .scrollContentBackground(.hidden)
        } else {
            content
        }
    }
}

extension View {
    func clearListBackground() -> some View {
        modifier(ClearListBackgroundModifier())
    }
}
